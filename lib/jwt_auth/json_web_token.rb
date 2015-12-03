class JsonWebToken

  include ActiveModel::Model
  require 'jwt'

  attr_reader :user_id, :payload

  def self.secret_and_encoding
    s = nil
    e = nil
    self.find_config do |app, secret, encoding|
      s = secret
      e = encoding
    end
    [s, e]
  end

  def self.find_config
      yield Rails.application.class.parent_name.underscore,
        Rails.application.secrets.json_web_token_secret
        Rails.application.secrets.json_web_token_encoding
  end
  def self.encode(user_id, expiration = 24.hours.from_now)
    secret, encoding = secret_and_encoding
    JWT.encode({user_id: user_id, exp: expiration.to_i}, secret, encoding)
  end

  def initialize token
    # begin
      secret, encoding = secret_and_encoding
      @payload = JWT.decode(token, secret, encoding).first.with_indifferent_access
      @user_id = @payload[:user_id]["$oid"]
    # rescue JWT::DecodeError
      # nil
    # end
  end

  def valid?
    user_id.presence && Time.now < Time.at(@payload[:exp].to_i)
  end

end
