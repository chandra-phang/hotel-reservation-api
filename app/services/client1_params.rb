class Client1Params
  def initialize(current_user)
    @current_user = current_user
  end

  def guest_params(params)
    params = params.delete(:guest)

    guest = {}
    guest[:first_name] = params[:first_name]
    guest[:last_name] = params[:last_name]
    guest[:email] = params[:email]
    guest[:external_id] = params[:id]
    guest[:phone_number] = params[:phone]
    guest[:creator_id] = @current_user.id

    guest
  end

  def reservation_params(params)
    reservation = {}
    reservation[:status] = params[:status]
    reservation[:start_date] = params[:start_date]
    reservation[:end_date] = params[:end_date]
    reservation[:nights] = params[:nights]
    reservation[:total_guest] = params[:guests]
    reservation[:children_guest] = params[:children]
    reservation[:adult_guest] = params[:adults]
    reservation[:infant_guest] = params[:infants]
    reservation[:creator_id] = @current_user.id

    reservation
  end

  def invoice_params(params)
    invoice = {}
    invoice[:currency] = params[:currency]
    invoice[:total_paid_amount] = params[:payout_price]
    invoice[:security_price] = params[:security_price]
    invoice[:total_price] = params[:total_price]
    invoice[:creator_id] = @current_user.id

    invoice
  end
end
