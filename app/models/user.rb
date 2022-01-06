class User < ApplicationRecord

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

  end

  def self.ldap_authenticate(params)
    ldap = Net::LDAP.new(:base => ENV["LDAP_BASE"], :host => ENV["LDAP_HOST"])
    ldap.auth ENV["LDAP_Service_Account"], ENV["LDAP_PASSWORD"]

    if ldap.bind(:method => :simple, :username => ENV["LDAP_DN"], :password => ENV["LDAP_PASSWORD"])
      usr = params[:username]
      usr_password = params[:password]

      user_dn = ldap.search(filter: Net::LDAP::Filter.eq("sAMAccountName", "#{usr.to_s.strip}"),
                            attributes: %w[ dn ], return_result: true).first.dn rescue nil

      if user_dn != nil
        results = ldap.bind(:method => :simple, :username => user_dn.to_s.strip, :password => usr_password.to_s.strip)

        if results
          # authentication succeeded
          return usr
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end
end
