module JWTUserAuth
  def auth_token
    JsonWebToken.encode(self.id)
  end


  def as_json(options={})
    res =  super(options)
    res['auth_token'] = self.auth_token
    res
  end
end