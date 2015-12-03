# JwtAuth

It helps to authenticate devise user using JSON Web Token.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jwt_auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jwt_auth

## Usage

Install devise user. Right now it only works for 'User'.

Add following code :

```ruby
# in application_controller.rb
class ApplicationController < ActionController::Base
  include JwtAuthentication
  #...
end
```

```ruby
# in models/user.rb
class User
  include JWTUserAuth
  #...
end
```

After sign_in devise will return auth_token in JSON object.

Ex:

```json
{
  "id": 1,
  "created_at": "2015-12-01T11:04:26.224Z",
  "email": "*****@gmail.com",
  "updated_at": "2015-12-01T11:07:55.354Z",
  "auth_token": "eyJ0eXAiOiJKV1Qi******-CtGZag",
}
```
After this with each request where authentication is required in headers pass the 'Authorization' which has the same as auth_token received in above json.

Add devise default before filter for authentication.

```ruby
before_filter :authenticate_user!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/suratpyari/jwt_authentication. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

