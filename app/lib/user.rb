module RPS_Logic
  class User
    attr_reader :name, :profile_picture, :user_id, :join_at
    def initialize(name, password_digest, email, profile_picture=nil, join_at=nil, user_id=nil)
      @name = name
      @password_digest = password_digest
      @email = email
      @profile_picture = profile_picture
      @join_at = join_at
      @user_id = user_id
    end
  end
  
end