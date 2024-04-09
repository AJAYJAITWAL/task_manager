module AuthHelper
  def generate_jwt_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.secrets.secret_key_base.to_s, 'HS256')
  end
end
