module JwtAuthentication

  def authenticate_user!(options={})
    respond_to do |format|
      format.html{super(options)}
      format.json{unauthorized! unless current_user}
    end
  end

  def unauthorized!
    head :unauthorized
  end

  def current_user
    respond_to do |format|
      format.html{super}
      format.json{@current_user ||= set_current_user}
    end
  end

  def set_current_user
    token = request.headers['Authorization'].to_s.split(' ').last
    return unless token
    payload = JsonWebToken.new(token)
    @current_user = User.find(payload.user_id) if payload.valid?
  end

  def show_authentication_messages
    respond_to do |format|
      format.html{super}
      format.json{
        if @user.errors.any?
          render :json=> @user.errors, :status=>422
        else
          render :json=>{:success=>true}, :status=>201
        end
      }
    end
  end

end
