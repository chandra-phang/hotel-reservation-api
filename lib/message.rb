class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.unauthorized
    'Request not allowed'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_updated
    'Account updated successfully'
  end

  def self.account_deleted
    'Account deleted successfully'
  end

  def self.reservation_created
    'Reservation created successfully'
  end

  def self.reservation_updated
    'Reservation updated successfully'
  end

  def self.reservation_deleted
    'Reservation deleted successfully'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end
end
