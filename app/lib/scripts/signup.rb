module RPS
  class SignUp
    def self.run(params)
      if params['email'].empty? || params['password'].empty? || params['password_conf'].empty? || params['screenname'].empty?
        return {:success? => false, :error => "EMPTY FIELDS"}
      elsif RPS::DBI.dbi.user_exists?(params['email'])
        return {:success? => false, :error => "USER ALREADY EXISTS"}
      elsif params['password'] != params['password_conf']
        return {:success? => false, :error => "PASSWORDS DONT MATCH"}
      end

      email = params['email'].downcase.strip #need for Gravatar
      user = RPS::User.new(params['screenname'], email)
      user.update_password(params['password'])
      user.set_profile_pic
      RPS::DBI.dbi.save_user(user)
      
      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end