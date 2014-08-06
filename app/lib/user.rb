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
      { wins: wins, 
       all_matches: all_matches,
       completed_matches: completed_matches,
       wins_percentage: wins_percentage
      }
    end 
  end   
end