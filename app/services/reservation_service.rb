class ReservationService
  def initialize(current_user)
    @current_user = current_user
  end

  def all
    reservations = Reservation.includes(:invoice, :guest)
                              .where(creator_id: @current_user.id)
    reservations.map{ |reservation| get_full_reservation(reservation) }
  end

  def show(id)
    reservation = Reservation.find(id)
    if reservation.creator_id != @current_user.id
      raise ExceptionHandler::Unauthorized
    end
    get_full_reservation(reservation)
  end

  def create(params, client = "client_1")
    guest_params, reservation_params, invoice_params = prepare_params(params, client)

    ActiveRecord::Base.transaction do
      guest = Guest.first_or_initialize(guest_params)
      guest.save!

      reservation = Reservation.new(reservation_params)
      reservation.guest_id = guest.id
      reservation.save!

      invoice = reservation.build_invoice(invoice_params)
      invoice.guest_id = guest.id
      invoice.save!

      get_full_reservation(reservation)
    end
  end

  def update(id, params, client = "client_1")
    reservation = Reservation.find(id)

    if reservation.creator_id != @current_user.id
      raise ExceptionHandler::Unauthorized
    end

    guest_params, reservation_params, invoice_params = prepare_params(params, client)

    ActiveRecord::Base.transaction do
      guest = Guest.first_or_initialize(guest_params)
      guest.save!

      reservation.update!(reservation_params)
      reservation.update!(guest_id: guest.id)

      if reservation.invoice
        reservation.invoice.update!(invoice_params)
        invoice = reservation.invoice
      else
        invoice = reservation.build_invoice(invoice_params)
      end

      invoice.guest_id = guest.id
      invoice.save!

      get_full_reservation(reservation)
    end
  end

  def delete(id)
    reservation = Reservation.find(id)
    if reservation.creator_id != @current_user.id
      raise ExceptionHandler::Unauthorized
    end
    reservation.deleted!
    get_full_reservation(reservation)
  end

  private

  def prepare_params(params, client)
    strategy =
      case client
      when "client_1" then Client1Params.new(@current_user)
      when "client_2" then Client2Params.new(@current_user)
      end

    guest_params = strategy.guest_params(params)
    reservation_params = strategy.reservation_params(params)
    invoice_params = strategy.invoice_params(params)

    [guest_params, reservation_params, invoice_params]
  end

  def get_full_reservation(reservation)
    attributes = reservation.attributes
    attributes[:guest] = reservation.guest.attributes
    attributes[:invoice] = reservation.invoice
    attributes
  end
end
