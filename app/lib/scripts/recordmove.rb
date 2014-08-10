module RPS
  class RecordMove
    def self.run(current_user_id, this_match_id, this_round_id, this_move)
      current_user = RPS::GetUserInfo.run(current_user_id)
      this_match = current_user.matches.find{|x| x.match_id == this_match_id}
      this_round = this_match.rounds.find{|x| x.round_id == this_round_id}

      #identify whether player is in position one or two in this match
      player_position = 1 if current_user_id == this_match.player_1_id 
      player_position = 2 if current_user_id == this_match.player_2_id 

      #randomly assign value for ?
      if this_move == 'x'
        number = rand(3)
        this_move = 'r' if number == 0
        this_move = 's' if number == 1
        this_move = 'p' if number == 2
      end

      #update round object
      if player_position == 1
        this_round.player_1_move!(this_move)
      elsif player_position == 2
        this_round.player_2_move!(this_move)
      end

      result = this_round.result 
      #check if match is completed (3 games won) and set complete to t if so    
      # .completed! also sets the winner id 
      match_completed = this_match.completed!
            
      #create another round if the match is not complete, but both players have played this round      
      if !result.nil? and !match_completed
        another_round = RPS::Round.new(this_match_id, this_match.new_round_id)
        another_round = RPS::DBI.dbi.save_round(another_round)
      end

      #update the result of this round if both players have played
      if !result.nil?
        RPS::DBI.dbi.update_result(this_round)
      end

      #update the move that was made in the round
      if !this_round.player_1_move.nil?
        RPS::DBI.dbi.update_player_1_move(this_round)
      end

      if !this_round.player_2_move.nil?
        RPS::DBI.dbi.update_player_2_move(this_round)
      end

      #if the match is completed, update the match so completed and winner id are saved in db
      if match_completed
        RPS::DBI.dbi.update_match(this_match)
      end
      
      #set message for feedback page
      if result == nil
        this_message = "WAITING FOR OPPONENT"
      elsif result == 0
        this_message = "TIED ROUND"
      elsif !match_completed && result == player_position 
        this_message = "YOU WON THIS ROUND!"
      elsif !match_completed && result != player_position
        this_message = "YOU LOST THIS ROUND."
      elsif match_completed && this_match.winner_id == current_user_id
        this_message = "YOU WON THE MATCH!"
      elsif match_completed && this_match.winner_id != current_user_id
        this_message = "YOU LOST THE MATCH."
      end

      this_message
    end
  end
end