class ReservationsController < ApplicationController
  def index
    reservations = service.all
    json_response(reservations)
  end

  def show
    reservation = service.show(params[:id])
    json_response(reservation)
  end

  def create
    if params[:guest].present?
      reservation_params = validate_client_1_params!
      reservation = service.create(reservation_params, "client_1")
    else
      reservation_params = validate_client_2_params!
      reservation = service.create(reservation_params, "client_2")
    end
    response = {
      message: Message.reservation_created,
      reservation: reservation
    }
    json_response(reservation, :created)
  end

  def update
    if params[:guest].present?
      reservation_params = validate_client_1_params!
      reservation = service.update(params[:id], reservation_params, "client_1")
    else
      reservation_params = validate_client_2_params!
      reservation = service.update(params[:id], reservation_params, "client_2")
    end
    response = {
      message: Message.reservation_updated,
      reservation: reservation
    }
    json_response(response)
  end

  def destroy
    reservation = service.delete(params[:id])
    response = {
      message: Message.reservation_deleted,
      reservation: reservation
    }
    json_response(response)
  end

  private

  def service
    ReservationService.new(current_user)
  end

  def validate_client_1_params!
    param! :start_date,     String, required: true
    param! :end_date,       String, required: true
    param! :nights,         Integer, required: true
    param! :guests,         Integer, required: true
    param! :adults,         Integer, required: true
    param! :children,       Integer, required: true
    param! :infants,        Integer, required: true
    param! :status,         String, required: true, in: Reservation.statuses.keys
    param! :currency,       String, required: true
    param! :payout_price,   String, required: true
    param! :security_price, String, required: true
    param! :total_price,    String, required: true

    param! :guest, Hash, required: true do |g|
      g.param! :id,         Integer, required: true
      g.param! :first_name, String, required: true
      g.param! :last_name,  String, required: true
      g.param! :phone,      String, required: true
      g.param! :email,      String, required: true
    end

    params.permit(
      :start_date, :end_date, :nights, :guests, :adults, :children, :infants, :status,
      :currency, :payout_price, :security_price, :total_price,
      guest: [:id, :first_name, :last_name, :phone, :email]
    )
  end

  def validate_client_2_params!
    param! :reservation, Hash, required: true do |r|
      r.param! :start_date,                       String, required: true
      r.param! :end_date,                         String, required: true
      r.param! :expected_payout_amount,           String, required: true
      r.param! :guest_email,                      String, required: true
      r.param! :guest_first_name,                 String, required: true
      r.param! :guest_id,                         Integer, required: true
      r.param! :guest_last_name,                  String, required: true
      r.param! :listing_security_price_accurate,  String, required: true
      r.param! :host_currency,                    String, required: true
      r.param! :nights,                           Integer, required: true
      r.param! :number_of_guests,                 Integer, required: true
      r.param! :status_type,                      String, required: true, in: Reservation.statuses.keys
      r.param! :total_paid_amount_accurate,       String, required: true

      r.param! :guest_details, Hash, required: true do |g|
        g.param! :localized_description,  String, required: true
        g.param! :number_of_adults,       Integer, required: true
        g.param! :number_of_children,     Integer, required: true
        g.param! :number_of_infants,      Integer, required: true
      end

      r.param! :guest_phone_numbers, Array, required: true do |array, index|
        array.param! index, String, required: true
      end
    end

    params.require(:reservation).permit(
      :start_date, :end_date, :expected_payout_amount, :guest_email,
      :guest_first_name, :guest_id, :guest_last_name,
      :listing_security_price_accurate, :host_currency, :nights,
      :number_of_guests, :status_type, :total_paid_amount_accurate,
      guest_details: [
        :localized_description, :number_of_adults,
        :number_of_children, :number_of_infants
      ],
      guest_phone_numbers: []
    )
  end
end
