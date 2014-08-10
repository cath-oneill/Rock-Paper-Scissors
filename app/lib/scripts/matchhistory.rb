module RPS
	class MatchHistory

    def self.run(user_id, match_id)
      player_position = RPS::GetPlayerPosition.run(user_id, match_id)
      history = RPS::DBI.dbi.get_rounds_by_match_id(match_id)

      returned_value = []

      history.each do |x|
        this_round = {}
        this_round[:round_id] = x.round_id
        if x.result==0
          this_round[:result] = 'TIED ROUND'
        elsif x.result == player_position
          this_round[:result] = 'YOU WON!'
        elsif x.result.nil?
          this_round[:result] = nil
        else 
          this_round[:result] = 'YOU LOST!'
        end
        if player_position == 1
          this_round[:your_move] = RPS::MatchHistory.convert_play_to_word(x.player_1_move)
          this_round[:their_move] = RPS::MatchHistory.convert_play_to_word(x.player_2_move)
        else 
          this_round[:your_move] = RPS::MatchHistory.convert_play_to_word(x.player_2_move)
          this_round[:their_move] = RPS::MatchHistory.convert_play_to_word(x.player_1_move)
        end
        returned_value << this_round
      end          

      returned_value
    end

    def self.convert_play_to_word(play)
      if play == 'r'
        return 'ROCK'
      elsif play == 'p'
        return 'PAPER'
      elsif play == 's'
        return 'SCISSORS'
      end
    end


  end
end