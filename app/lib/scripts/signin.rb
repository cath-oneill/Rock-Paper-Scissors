module RPS_Scripts
  class SignIn
    def self.run(params)
      if params['email'].empty? || params['password'].empty?
        return {:success? => false, :error => "BLANK ENTRIES"}
      end

      user = DBI.dbi.get_user_by_email(params['email'])
      return {:success? => false, :error => "NO SUCH USER"} if !user

      if !user.has_password?(params['password'])
        return {:success? => false, :error => "BAD PASSWORD"}
      end

      {
        :success? => true,
        :session_id => user.username
      }
    end
  end
end