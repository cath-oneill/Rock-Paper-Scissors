module RPS_Logic
  class Match
    attr_reader :player_1_id, :player_2_id, :match_id, :start_at, :completed
    def initialize(player_1_id, player_2_id, match_id=nil, start_at=nil, completed=nil, winner_id=nil)
      @player_1_id = player_1_id
      @player_2_id = player_2_id
      @match_id = match_id
      @start_at = start_at
      @completed = completed
      @winner_id = winner_id
    end

    def winner(player)
      if player == 1
        @winner_id = @player_1_id
      elsif player == 2
        @winner_id = @player_2_id
      end
    end
  end
end