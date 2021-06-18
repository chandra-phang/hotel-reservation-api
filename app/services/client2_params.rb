class Client2Params
  def initialize(current_user)
    @current_user = current_user
  end

  def guest_params(params)
    guest = {}
    guest[:first_name] = params[:guest_first_name]
    guest[:last_name] = params[:guest_last_name]
    guest[:email] = params[:guest_email]
    guest[:external_id] = params[:guest_id]
    guest[:phone_number] = params[:guest_phone_numbers]&.first
    guest[:creator_id] = @current_user.id

    guest
  end

  def reservation_params(params)
    guest_details = params[:guest_details]

    reservation = {}
    reservation[:status] = params[:status_type]
    reservation[:start_date] = params[:start_date]
    reservation[:end_date] = params[:end_date]
    reservation[:nights] = params[:nights]
    reservation[:total_guest] = guest_details["localized_description"].split(" ").first
    reservation[:children_guest] = guest_details["number_of_children"]
    reservation[:adult_guest] = guest_details["number_of_adults"]
    reservation[:infant_guest] = guest_details["number_of_infants"]
    reservation[:creator_id] = @current_user.id

    reservation
  end

  def invoice_params(params)
    invoice = {}
    invoice[:currency] = params[:host_currency]
    invoice[:total_paid_amount] = params[:expected_payout_amount]
    invoice[:security_price] = params[:listing_security_price_accurate]
    invoice[:total_price] = params[:total_paid_amount_accurate]
    invoice[:creator_id] = @current_user.id

    invoice
  end
end
