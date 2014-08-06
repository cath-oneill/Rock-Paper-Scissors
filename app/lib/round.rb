module RPS_Logic
  class Round
    attr_reader :match_id, :round_id
    def initialize(match_id, round_id, player_1_move = nil, player_2_move = nil, result)
      @match_id = match_id
      @round_id = round_id
      @player_1_move = player_1_move
      @player_2_move = player_2_move
      @result = result
    end

    
  end
end