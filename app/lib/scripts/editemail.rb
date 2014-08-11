module RPS
  class EditEmail

    def self.run(params, user)
      if params['email'].empty? 
        return {:success? => false, :message => "EMPTY FIELDS"}
      end

      email = params['email'].downcase.strip #need for Gravatar
      user.update_email(email)
      user.set_profile_pic
      RPS::DBI.dbi.update_user(user)
      
      { :success? => true,
        :message => "EMAIL UPDATED"
      }

    end

  end
end