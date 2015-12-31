module JwtAuthentication
  Devise.mappings.keys.collect(&:to_s).each do |u|
    define_method "authenticate_#{u}!" do
      respond_to do |format|
        format.html{
          ActionController::Base.instance_method("authenticate_#{u}!".to_sym).bind(self).call
        }
        format.json{unauthorized! unless eval("current_#{u}")}
      end
    end
  
    define_method "current_#{u}" do
      respond_to do |format|
        format.html{
          ActionController::Base.instance_method("current_#{u}".to_sym).bind(self).call
        }
        format.json{eval("@current_#{u} ||= set_current_#{u}")}
      end
    end
  
    define_method "set_current_#{u}" do
      token = request.headers['Authorization'].to_s.split(' ').last
      return unless token
      payload = JsonWebToken.new(token)
      eval("@current_#{u} = #{u.capitalize}.find(payload.user_id)") if payload.valid?
    end
  end
  
  def show_authentication_messages
    respond_to do |format|
      format.html{super}
      format.json{
        Devise.mappings.keys.collect(&:to_s).each do |u|
          return render(:json=> eval("@#{u}.errors"), :status=>422) if eval("@#{u} && @#{u}.errors.any?")
        end
        render :json=>{:success=>true}, :status=>201
      }
    end
  end
  
  
  def unauthorized!
    head :unauthorized
  end

end
