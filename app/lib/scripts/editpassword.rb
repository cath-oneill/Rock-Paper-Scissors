module RPS
  class EditPassword
    def self.run(params, user)
      if params['password'].empty? || params['password_conf'].empty? 
        return {:success? => false, :message => "EMPTY FIELDS"}
      elsif params['password'] != params['password_conf']
        return {:success? => false, :message => "PASSWORDS DONT MATCH"}
      end

      user.update_password(params['password'])
      RPS::DBI.dbi.update_user(user)
      
      { :success? => true,
        :message => "PASSWORD UPDATED"
      }
    end
  end
end