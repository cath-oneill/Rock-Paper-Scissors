module DBI
  class SignUp
    def self.run(params)
      if params['username'].empty? || params['password'].empty? || params['password_conf'].empty?
        return {:success? => false, :error => "EMPTY FIELDS"}
      elsif DBI.dbi.username_exists?(params['username'])
        return {:success? => false, :error => "USER ALREADY EXISTS"}
      elsif params['password'] != params['password_conf']
        return {:success? => false, :error => "PASSWORDS DONT MATCH"}
      end

      user = DBI::User.new(params['username'])
      user.update_password(params['password'])
      DBI.dbi.persist_user(user)
      
      {
        :success? => true,
        :session_id => user.username
      }
    end
  end
end