require 'digest/sha1'

module RPS_Logic
  class User
    attr_reader :name, :profile_picture, :user_id, :join_at
    def initialize(name, email, password_digest=nil, profile_picture=nil, join_at=nil, user_id=nil)
      @name = name
      @email = email
      @password_digest = password_digest
      @profile_picture = profile_picture
      @join_at = join_at
      @user_id = user_id
      @matches = []
    end


    def wins
      wins = 0 
      @matches.each do |match| 
        if match.winner_id == user_id
          win +=1
        end 
      end 
      wins 
    end   

    def all_matches
       @matches.count
    end

    def completed_matches
      stats = 0
      @matches.each do |match| 
        if match.completed == true
          stats +=1
        end       
      end 
      stats
    end   
    
    def wins_percentage
      wins.to_f/ completed_matches
    end   

    def stats 
      {wins: wins, 
       all_matches: all_matches,
       completed_matches: completed_matches,
       wins_percentage: wins_percentage
      }
    end 

    def update_password(password)
      @password_digest = Digest::SHA1.hexdigest(password)
    end

    def has_password?(password)
      Digest::SHA1.hexdigest(password) == @password_digest
    end
  end   
end