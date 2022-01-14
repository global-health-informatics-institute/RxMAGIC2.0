require 'net/ldap'

class Ldap
  attr_accessor :ldap_connection, :params, :ldap_response
  def initialize(params = {})
    self.ldap_connection = connect_to_ldap_server()
    self.params = params
  end

  def connect_to_ldap_server
    ldap = Net::LDAP.new :host => ENV['LDAP_HOST'],
    :port => 389,
    :base => ENV['LDAP_BASE'],
    :auth => {
      method: :simple,
      username: ENV['LDAP_Service_Account'],
      password: ENV['LDAP_PASSWORD']
    }

    if ldap.bind
      puts "authentication succeeded"

    else
      puts "authentication failed"
    end
    ldap
  end


  #to Authenticate User
  def authenticate_user(username,password)
    result = ldap_connection.bind_as(
    :base => ENV['LDAP_BASE'],
    :filter => "(uid=#{username})",
    :password => password
    )
    if result
      return result
    end
  end
end
