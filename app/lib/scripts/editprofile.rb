module RPS
  class EditProfile
    def self.run(params)
      if params['password'].empty? || params['password_conf'].empty? 
        return {:success? => false, :error => "EMPTY FIELDS"}
      elsif params['password'] != params['password_conf']
        return {:success? => false, :error => "PASSWORDS DONT MATCH"}
      end

      user = RPS::DBI.dbi.get_user_by_id(session['rps'])
      user.update_password(params['password'])
      RPS::DBI.dbi.save_user(user)
      
      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end