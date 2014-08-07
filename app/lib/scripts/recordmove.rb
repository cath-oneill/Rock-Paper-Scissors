module RPS
  class RecordMove
    def self.run(current_user_id, this_match_id, this_round_id, this_move)
      current_user = RPS::GetUserInfo.run(current_user_id)
      this_match = current_user.matches.find{|x| x.match_id == this_match_id}
      this_round = this_match.rounds.find{|x| x.round_id == this_round_id}

      player_position = 1 if current_user_id == this_match.player_1_id 
      player_position = 2 if current_user_id == this_match.player_2_id 

      if player_position == 1
        this_round.player_1_move!(this_move)
      elsif player_position == 2
        this_round.player_2_move!(this_move)
      end

      result = this_round.result
      match_completed = this_match.completed!
      
      if match_completed == 1 || 2
        another_round = RPS::Round.new(this_match_id, this_match.new_round_id)
        another_round = RPS::DBI.dbi.save_round(another_round)
      end

      if result == 0
        this_message = "waiting for opponent"
      elsif !match_completed 
        if result == player_position 
          this_message = "you won the round"
        elsif result != player_position
          this_message = "you lost the round"
        end
      elsif match_completed == player_position
        this_message = "you won the match"
      elsif match_completed != player_position
        this_message = "you lost the match"
      end
      ## UPDATE ROUND AND MATCH
      this_message
    end
  end
end