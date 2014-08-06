module RPS_Logic
  class Round
    attr_reader :match_id, :round_id
    def initialize(match_id, round_id, player_1_move = nil, player_2_move = nil, result=nil)
      @match_id = match_id
      @round_id = round_id
      @player_1_move = player_1_move
      @player_2_move = player_2_move
      @result = result
    end

    def result
      if @player_1_move.nil? || @player_2_move.nil?
        return @result = nil
      elsif @player_1_move == @player_2_move
        @result = 0
      elsif @player_1_move == "r"
        if @player_2_move == "s"
         @result = 1
        elsif @player_2_move == "p"
           @result = 2
        end
      elsif @player_1_move == "s"
        if @player_2_move == "r"
           @result = 2
        elsif @player_2_move == "p"
           @result = 1
        end
      elsif @player_1_move == "p"
        if @player_2_move == "r"
           @result = 1
        elsif @player_2_move == "s"
           @result = 2
        end
      end
      @result
    end

    def player_1_move! (play)
      if play == "r" || play =="s" || play == "p"
        @player_1_move = play
      end
    end 


    def player_2_move! (play)
      if play == "r" || play =="s" || play == "p"
        @player_2_move = play
      end
    end 

    def round_info
      {round: @round_id, 
       player_1_move: @player_1_move,
       player_2_move: @player_2_move, 
       result: @result
       }
    end
  end
end