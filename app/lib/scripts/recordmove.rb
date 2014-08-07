module RPS
  class RecordMove
    def self.run(current_user_id, this_match_id, this_round_id, this_move)
      current_user = RPS::GetUserInfo(current_user_id)
      this_match = current_user.matches.find_if{|x| x.match_id == this_match_id}
      this_round = this_match.rounds.find_if{|x| x.round_id == this_round_id}

      current_user_id == this_match.player_1_id ? player_position = 1
      current_user_id == this_match.player_2_id ? player_position = 2

      if player_position == 1
        this_round.player_1_move!(this_move)
      elsif player_position == 2
        this_round.player_2_move!(this_move)
      end

      result = this_round.result
      match_completed = this_match.completed!

      if result == 0
        message = :waiting_for_opponent
      elsif !match_completed 
        if result == player_position 
          message = :you_won_round
        elsif result != player_position
          message = :you_lost_round
        end
      elsif match_completed == player_position
        message = :you_won_match
      elsif match_completed != player_position
        message = :you_lost_match
      end

      message
    end
  end
end