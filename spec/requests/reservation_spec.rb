require 'rails_helper'

RSpec.describe 'Reservation API', type: :request do
  before do
    @params = {
      reservation: {
        start_date: "2021-03-12",
        end_date: "2021-03-16",
        expected_payout_amount: "3800.00",
        guest_details: {
          localized_description: "4 guests",
          number_of_adults: 2,
          number_of_children: 2,
          number_of_infants: 0
        },
        guest_email: "wayne_woodbridge@bnb.com",
        guest_first_name: "Wayne",
        guest_id: 1,
        guest_last_name: "Woodbridge",
        guest_phone_numbers: [
          "639123456789",
          "639123456789"
        ],
        listing_security_price_accurate: "500.00",
        host_currency: "AUD",
        nights: 4,
        number_of_guests: 4,
        status_type: "accepted",
        total_paid_amount_accurate: "4500.00"
      }
    }
    post '/reservations', params: @params.to_json, headers: valid_headers
  end

  let(:user) { create(:user) }
  let(:reservation) { Reservation.first }
  let(:invoice) { reservation.invoice }
  let(:guest) { reservation.guest }

  describe 'Index' do
    context 'when valid request' do
      before { get "/reservations/", params: {}, headers: valid_headers }

      it 'creates a new reservation' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        first_reservation = json.first

        expect(first_reservation["status"]).to eq(reservation.status)
        expect(first_reservation["start_date"]).to eq(reservation.start_date.iso8601(3))
        expect(first_reservation["end_date"]).to eq(reservation.end_date.iso8601(3))
        expect(first_reservation["nights"]).to eq(reservation.nights)
        expect(first_reservation["total_guest"]).to eq(reservation.total_guest)
        expect(first_reservation["adult_guest"]).to eq(reservation.adult_guest)
        expect(first_reservation["children_guest"]).to eq(reservation.children_guest)
        expect(first_reservation["infant_guest"]).to eq(reservation.infant_guest)
        expect(first_reservation["creator_id"]).to eq(reservation.creator_id)
        expect(first_reservation["guest_id"]).to eq(reservation.guest_id)
        expect(first_reservation["created_at"]).to eq(reservation.created_at.iso8601(3))
        expect(first_reservation["updated_at"]).to eq(reservation.updated_at.iso8601(3))

        expect(first_reservation["invoice"]["total_paid_amount"]).to eq(invoice.total_paid_amount)
        expect(first_reservation["invoice"]["security_price"]).to eq(invoice.security_price)
        expect(first_reservation["invoice"]["total_price"]).to eq(invoice.total_price)
        expect(first_reservation["invoice"]["currency"]).to eq(invoice.currency)
        expect(first_reservation["invoice"]["creator_id"]).to eq(invoice.creator_id)
        expect(first_reservation["invoice"]["guest_id"]).to eq(invoice.guest_id)
        expect(first_reservation["invoice"]["reservation_id"]).to eq(invoice.reservation_id)

        expect(first_reservation["guest"]["email"]).to eq(guest.email)
        expect(first_reservation["guest"]["first_name"]).to eq(guest.first_name)
        expect(first_reservation["guest"]["last_name"]).to eq(guest.last_name)
        expect(first_reservation["guest"]["phone_number"]).to eq(guest.phone_number)
        expect(first_reservation["guest"]["creator_id"]).to eq(guest.creator_id)
        expect(first_reservation["guest"]["external_id"]).to eq(guest.external_id)
      end
    end
  end

  describe 'Show' do
    context 'when valid params' do
      before { get "/reservations/#{reservation.id}", params: {}, headers: valid_headers }

      it 'creates a new reservation' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        expect(json["status"]).to eq(reservation.status)
        expect(json["start_date"]).to eq(reservation.start_date.iso8601(3))
        expect(json["end_date"]).to eq(reservation.end_date.iso8601(3))
        expect(json["nights"]).to eq(reservation.nights)
        expect(json["total_guest"]).to eq(reservation.total_guest)
        expect(json["adult_guest"]).to eq(reservation.adult_guest)
        expect(json["children_guest"]).to eq(reservation.children_guest)
        expect(json["infant_guest"]).to eq(reservation.infant_guest)
        expect(json["creator_id"]).to eq(reservation.creator_id)
        expect(json["guest_id"]).to eq(reservation.guest_id)
        expect(json["created_at"]).to eq(reservation.created_at.iso8601(3))
        expect(json["updated_at"]).to eq(reservation.updated_at.iso8601(3))

        expect(json["invoice"]["total_paid_amount"]).to eq(invoice.total_paid_amount)
        expect(json["invoice"]["security_price"]).to eq(invoice.security_price)
        expect(json["invoice"]["total_price"]).to eq(invoice.total_price)
        expect(json["invoice"]["currency"]).to eq(invoice.currency)
        expect(json["invoice"]["creator_id"]).to eq(invoice.creator_id)
        expect(json["invoice"]["guest_id"]).to eq(invoice.guest_id)
        expect(json["invoice"]["reservation_id"]).to eq(invoice.reservation_id)

        expect(json["guest"]["email"]).to eq(guest.email)
        expect(json["guest"]["first_name"]).to eq(guest.first_name)
        expect(json["guest"]["last_name"]).to eq(guest.last_name)
        expect(json["guest"]["phone_number"]).to eq(guest.phone_number)
        expect(json["guest"]["creator_id"]).to eq(guest.creator_id)
        expect(json["guest"]["external_id"]).to eq(guest.external_id)
      end
    end

    context 'when invalid reservation_id' do
      before { get "/reservations/-100", params: {}, headers: valid_headers }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Couldn't find Reservation with 'id'=-100/)
      end
    end
  end

  describe 'Create by client1 params' do
    context 'when valid params' do
      before do
        params = {
          start_date: "2021-03-12",
          end_date: "2021-03-16",
          nights: 4,
          guests: 4,
          adults: 2,
          children: 2,
          infants: 0,
          status: "accepted",
          guest: {
            id: 1,
            first_name: "Wayne",
            last_name: "Woodbridge",
            phone: "639123456789",
            email: "wayne_woodbridge@bnb.com"
          },
          currency: "AUD",
          payout_price: "3800.00",
          security_price: "500",
          total_price: "4500.00"
        }
        post "/reservations/", params: params.to_json, headers: valid_headers
      end

      it 'creates a new reservation' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct attributes' do
        new_reservation = Reservation.find(json["id"])
        new_invoice = new_reservation.invoice
        new_guest = new_reservation.guest

        expect(json["status"]).to eq(new_reservation.status)
        expect(json["start_date"]).to eq(new_reservation.start_date.iso8601(3))
        expect(json["end_date"]).to eq(new_reservation.end_date.iso8601(3))
        expect(json["nights"]).to eq(new_reservation.nights)
        expect(json["total_guest"]).to eq(new_reservation.total_guest)
        expect(json["adult_guest"]).to eq(new_reservation.adult_guest)
        expect(json["children_guest"]).to eq(new_reservation.children_guest)
        expect(json["infant_guest"]).to eq(new_reservation.infant_guest)
        expect(json["creator_id"]).to eq(new_reservation.creator_id)
        expect(json["guest_id"]).to eq(new_reservation.guest_id)
        expect(json["created_at"]).to eq(new_reservation.created_at.iso8601(3))
        expect(json["updated_at"]).to eq(new_reservation.updated_at.iso8601(3))

        expect(json["invoice"]["total_paid_amount"]).to eq(new_invoice.total_paid_amount)
        expect(json["invoice"]["security_price"]).to eq(new_invoice.security_price)
        expect(json["invoice"]["total_price"]).to eq(new_invoice.total_price)
        expect(json["invoice"]["currency"]).to eq(new_invoice.currency)
        expect(json["invoice"]["creator_id"]).to eq(new_invoice.creator_id)
        expect(json["invoice"]["guest_id"]).to eq(new_invoice.guest_id)
        expect(json["invoice"]["reservation_id"]).to eq(new_invoice.reservation_id)

        expect(json["guest"]["email"]).to eq(new_guest.email)
        expect(json["guest"]["first_name"]).to eq(new_guest.first_name)
        expect(json["guest"]["last_name"]).to eq(new_guest.last_name)
        expect(json["guest"]["phone_number"]).to eq(new_guest.phone_number)
        expect(json["guest"]["creator_id"]).to eq(new_guest.creator_id)
        expect(json["guest"]["external_id"]).to eq(new_guest.external_id)
      end
    end

    context 'when invalid params' do
      before { post "/reservations/", params: {}, headers: valid_headers }

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Parameter start_date is required/)
      end
    end
  end

  describe 'Create by client2 params' do
    context 'when valid params' do
      before do
        post "/reservations/", params: @params.to_json, headers: valid_headers
      end

      it 'creates a new reservation' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct attributes' do
        new_reservation = Reservation.find(json["id"])
        new_invoice = new_reservation.invoice
        new_guest = new_reservation.guest

        expect(json["status"]).to eq(new_reservation.status)
        expect(json["start_date"]).to eq(new_reservation.start_date.iso8601(3))
        expect(json["end_date"]).to eq(new_reservation.end_date.iso8601(3))
        expect(json["nights"]).to eq(new_reservation.nights)
        expect(json["total_guest"]).to eq(new_reservation.total_guest)
        expect(json["adult_guest"]).to eq(new_reservation.adult_guest)
        expect(json["children_guest"]).to eq(new_reservation.children_guest)
        expect(json["infant_guest"]).to eq(new_reservation.infant_guest)
        expect(json["creator_id"]).to eq(new_reservation.creator_id)
        expect(json["guest_id"]).to eq(new_reservation.guest_id)
        expect(json["created_at"]).to eq(new_reservation.created_at.iso8601(3))
        expect(json["updated_at"]).to eq(new_reservation.updated_at.iso8601(3))

        expect(json["invoice"]["total_paid_amount"]).to eq(new_invoice.total_paid_amount)
        expect(json["invoice"]["security_price"]).to eq(new_invoice.security_price)
        expect(json["invoice"]["total_price"]).to eq(new_invoice.total_price)
        expect(json["invoice"]["currency"]).to eq(new_invoice.currency)
        expect(json["invoice"]["creator_id"]).to eq(new_invoice.creator_id)
        expect(json["invoice"]["guest_id"]).to eq(new_invoice.guest_id)
        expect(json["invoice"]["reservation_id"]).to eq(new_invoice.reservation_id)

        expect(json["guest"]["email"]).to eq(new_guest.email)
        expect(json["guest"]["first_name"]).to eq(new_guest.first_name)
        expect(json["guest"]["last_name"]).to eq(new_guest.last_name)
        expect(json["guest"]["phone_number"]).to eq(new_guest.phone_number)
        expect(json["guest"]["creator_id"]).to eq(new_guest.creator_id)
        expect(json["guest"]["external_id"]).to eq(new_guest.external_id)
      end
    end

    context 'when invalid params' do
      before { post "/reservations/", params: {}, headers: valid_headers }

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Parameter start_date is required/)
      end
    end
  end

  describe 'Destroy' do
    context 'when valid reservation_id' do
      before { delete "/reservations/#{reservation.id}", params: {}, headers: valid_headers }

      it 'returns ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        reservation.reload
        expect(json["message"]).to eq("Reservation deleted successfully")
        expect(json["reservation"]["status"]).to eq(reservation.status)
        expect(json["reservation"]["start_date"]).to eq(reservation.start_date.iso8601(3))
        expect(json["reservation"]["end_date"]).to eq(reservation.end_date.iso8601(3))
        expect(json["reservation"]["nights"]).to eq(reservation.nights)
        expect(json["reservation"]["total_guest"]).to eq(reservation.total_guest)
        expect(json["reservation"]["adult_guest"]).to eq(reservation.adult_guest)
        expect(json["reservation"]["children_guest"]).to eq(reservation.children_guest)
        expect(json["reservation"]["infant_guest"]).to eq(reservation.infant_guest)
        expect(json["reservation"]["creator_id"]).to eq(reservation.creator_id)
        expect(json["reservation"]["guest_id"]).to eq(reservation.guest_id)
        expect(json["reservation"]["created_at"]).to eq(reservation.created_at.iso8601(3))
        expect(json["reservation"]["updated_at"]).to eq(reservation.updated_at.iso8601(3))

        expect(json["reservation"]["invoice"]["total_paid_amount"]).to eq(invoice.total_paid_amount)
        expect(json["reservation"]["invoice"]["security_price"]).to eq(invoice.security_price)
        expect(json["reservation"]["invoice"]["total_price"]).to eq(invoice.total_price)
        expect(json["reservation"]["invoice"]["currency"]).to eq(invoice.currency)
        expect(json["reservation"]["invoice"]["creator_id"]).to eq(invoice.creator_id)
        expect(json["reservation"]["invoice"]["guest_id"]).to eq(invoice.guest_id)
        expect(json["reservation"]["invoice"]["reservation_id"]).to eq(invoice.reservation_id)

        expect(json["reservation"]["guest"]["email"]).to eq(guest.email)
        expect(json["reservation"]["guest"]["first_name"]).to eq(guest.first_name)
        expect(json["reservation"]["guest"]["last_name"]).to eq(guest.last_name)
        expect(json["reservation"]["guest"]["phone_number"]).to eq(guest.phone_number)
        expect(json["reservation"]["guest"]["creator_id"]).to eq(guest.creator_id)
        expect(json["reservation"]["guest"]["external_id"]).to eq(guest.external_id)
      end
    end

    context 'when invalid reservation_id' do
      before { delete "/reservations/-100", params: {}, headers: valid_headers }

      it 'returns not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Couldn't find Reservation with 'id'=-100/)
      end
    end
  end

  describe 'Update by client1 params' do
    context 'when valid params' do
      before do
        params = {
          start_date: "2021-03-12",
          end_date: "2021-03-16",
          nights: 4,
          guests: 2,
          adults: 0,
          children: 0,
          infants: 0,
          status: "cancelled",
          guest: {
            id: 1,
            first_name: "Wayne",
            last_name: "Woodbridge",
            phone: "639123456789",
            email: "wayne_woodbridge@bnb.com"
          },
          currency: "AUD",
          payout_price: "3800.00",
          security_price: "500",
          total_price: "4500.00"
        }
        patch "/reservations/#{reservation.id}", params: params.to_json, headers: valid_headers
      end

      it 'creates a new reservation' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        new_reservation = Reservation.find(json["reservation"]["id"])
        new_invoice = new_reservation.invoice
        new_guest = new_reservation.guest

        expect(json["message"]).to eq("Reservation updated successfully")
        expect(json["reservation"]["status"]).to eq(new_reservation.status)
        expect(json["reservation"]["start_date"]).to eq(new_reservation.start_date.iso8601(3))
        expect(json["reservation"]["end_date"]).to eq(new_reservation.end_date.iso8601(3))
        expect(json["reservation"]["nights"]).to eq(new_reservation.nights)
        expect(json["reservation"]["total_guest"]).to eq(new_reservation.total_guest)
        expect(json["reservation"]["adult_guest"]).to eq(new_reservation.adult_guest)
        expect(json["reservation"]["children_guest"]).to eq(new_reservation.children_guest)
        expect(json["reservation"]["infant_guest"]).to eq(new_reservation.infant_guest)
        expect(json["reservation"]["creator_id"]).to eq(new_reservation.creator_id)
        expect(json["reservation"]["guest_id"]).to eq(new_reservation.guest_id)
        expect(json["reservation"]["created_at"]).to eq(new_reservation.created_at.iso8601(3))
        expect(json["reservation"]["updated_at"]).to eq(new_reservation.updated_at.iso8601(3))

        expect(json["reservation"]["invoice"]["total_paid_amount"]).to eq(new_invoice.total_paid_amount)
        expect(json["reservation"]["invoice"]["security_price"]).to eq(new_invoice.security_price)
        expect(json["reservation"]["invoice"]["total_price"]).to eq(new_invoice.total_price)
        expect(json["reservation"]["invoice"]["currency"]).to eq(new_invoice.currency)
        expect(json["reservation"]["invoice"]["creator_id"]).to eq(new_invoice.creator_id)
        expect(json["reservation"]["invoice"]["guest_id"]).to eq(new_invoice.guest_id)
        expect(json["reservation"]["invoice"]["reservation_id"]).to eq(new_invoice.reservation_id)

        expect(json["reservation"]["guest"]["email"]).to eq(new_guest.email)
        expect(json["reservation"]["guest"]["first_name"]).to eq(new_guest.first_name)
        expect(json["reservation"]["guest"]["last_name"]).to eq(new_guest.last_name)
        expect(json["reservation"]["guest"]["phone_number"]).to eq(new_guest.phone_number)
        expect(json["reservation"]["guest"]["creator_id"]).to eq(new_guest.creator_id)
        expect(json["reservation"]["guest"]["external_id"]).to eq(new_guest.external_id)
      end
    end

    context 'when invalid params' do
      before { patch "/reservations/#{reservation.id}", params: {}, headers: valid_headers }

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Parameter start_date is required/)
      end
    end
  end

  describe 'Update by client2 params' do
    context 'when valid params' do
      before do
        patch "/reservations/#{reservation.id}", params: @params.to_json, headers: valid_headers
      end

      it 'creates a new reservation' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        new_reservation = Reservation.find(json["reservation"]["id"])
        new_invoice = new_reservation.invoice
        new_guest = new_reservation.guest

        expect(json["message"]).to eq("Reservation updated successfully")
        expect(json["reservation"]["status"]).to eq(new_reservation.status)
        expect(json["reservation"]["start_date"]).to eq(new_reservation.start_date.iso8601(3))
        expect(json["reservation"]["end_date"]).to eq(new_reservation.end_date.iso8601(3))
        expect(json["reservation"]["nights"]).to eq(new_reservation.nights)
        expect(json["reservation"]["total_guest"]).to eq(new_reservation.total_guest)
        expect(json["reservation"]["adult_guest"]).to eq(new_reservation.adult_guest)
        expect(json["reservation"]["children_guest"]).to eq(new_reservation.children_guest)
        expect(json["reservation"]["infant_guest"]).to eq(new_reservation.infant_guest)
        expect(json["reservation"]["creator_id"]).to eq(new_reservation.creator_id)
        expect(json["reservation"]["guest_id"]).to eq(new_reservation.guest_id)
        expect(json["reservation"]["created_at"]).to eq(new_reservation.created_at.iso8601(3))
        expect(json["reservation"]["updated_at"]).to eq(new_reservation.updated_at.iso8601(3))

        expect(json["reservation"]["invoice"]["total_paid_amount"]).to eq(new_invoice.total_paid_amount)
        expect(json["reservation"]["invoice"]["security_price"]).to eq(new_invoice.security_price)
        expect(json["reservation"]["invoice"]["total_price"]).to eq(new_invoice.total_price)
        expect(json["reservation"]["invoice"]["currency"]).to eq(new_invoice.currency)
        expect(json["reservation"]["invoice"]["creator_id"]).to eq(new_invoice.creator_id)
        expect(json["reservation"]["invoice"]["guest_id"]).to eq(new_invoice.guest_id)
        expect(json["reservation"]["invoice"]["reservation_id"]).to eq(new_invoice.reservation_id)

        expect(json["reservation"]["guest"]["email"]).to eq(new_guest.email)
        expect(json["reservation"]["guest"]["first_name"]).to eq(new_guest.first_name)
        expect(json["reservation"]["guest"]["last_name"]).to eq(new_guest.last_name)
        expect(json["reservation"]["guest"]["phone_number"]).to eq(new_guest.phone_number)
        expect(json["reservation"]["guest"]["creator_id"]).to eq(new_guest.creator_id)
        expect(json["reservation"]["guest"]["external_id"]).to eq(new_guest.external_id)
      end
    end

    context 'when invalid params' do
      before { patch "/reservations/#{reservation.id}", params: {}, headers: valid_headers }

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Parameter start_date is required/)
      end
    end
  end
end
