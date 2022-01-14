class User < ApplicationRecord
  has_one :user_credential, :foreign_key => :user_id
  validates :username, :presence => true, :uniqueness => true, :case_sensitive => false
  validates :user_role, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true


  def self.authenticate(params)
    #function to authenticate user based on current authentication method

    auth_method = YAML.load_file("#{Rails.root}/config/application.yml")["authentication"] rescue "local"

    case auth_method.downcase
    when "remote"
      return remote_authenticate(params)
    when "ldap"
      return ldap_authenticate(params)
    else
      return local_authenticate(params)
    end

  end

  def self.remote_authenticate(params)

  end

  def self.local_authenticate(params)
    user = User.where(username: params[:username]).first
    user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  def self.ldap_authenticate(params)
    auth = Ldap.new()
    return auth.authenticate_user(params[:username], params[:password])
  end
end
