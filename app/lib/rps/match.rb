module RPS
  class Match
    attr_reader :player_1_id, :player_2_id, :match_id, :start_at, :completed, :winner_id, :rounds
    def initialize(player_1_id, player_2_id, match_id=nil, start_at=nil, completed=nil, winner_id=nil)
      @player_1_id = player_1_id
      @player_2_id = player_2_id
      @match_id = match_id
      @start_at = start_at
      @completed = completed
      @winner_id = winner_id
      @rounds = []
    end

    def winner(player)
      if player == 1
        @winner_id = @player_1_id
      elsif player == 2
        @winner_id = @player_2_id
      end
      player
    end

    def completed!
      player1 = 0
      player2 = 0
      @rounds.each do |round|
        res = round.round_info[:result]
        if res == 1 
          player1 +=1
        elsif res == 2
          player2 +=1
        end 
      end
      if player1 == 3 || player2 == 3
        @completed = true  
        winner(1) if player1 == 3
        winner(2) if player2 == 3
        return true 
      else
        return false
      end       
    end 


    def new_round_id
      @rounds.length+1
    end  

  end
end