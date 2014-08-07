module RPS
  class GetMatchInfo
    def self.run(user)
      match_info = []
      user.matches.each do |x|
        this_match = {}
        if x.player_1_id == user.user_id
          player_number = 1
        elsif x.player_2_id == user.user_id
          player_number = 2
        end
        current_round_id = x.rounds.max_by { |y| y.round_id }.round_id
        current_round = x.rounds.max_by { |y| y.round_id }
        this_match[:match_id] = x.match_id
        this_match[:player_number] = player_number
        this_match[:completed] = x.completed
        this_match[:current_round] = current_round_id
        if player_number == 1 && current_round.player_1_move.nil?
          this_match[:already_played] = false;
        elsif player_number == 2 && current_round.player_2_move.nil?
          this_match[:already_played] = false;
        else
          this_match[:already_played] = true;
        end
        this_match[:current_wins] = x.rounds.count{|y| y.result == player_number}
        this_match[:current_ties] = x.rounds.count{|y| y.result == 0}
        if player_number == 1
          opponent = x.player_2_id
          this_match[:current_losses] = x.rounds.count{|y| y.result ==2}
        elsif player_number == 2
          opponent = x.player_1_id
          this_match[:current_losses] = x.rounds.count{|y| y.result == 1}
        end
        this_match[:opponent_id] = opponent
        this_match[:opponent_name] = RPS::DBI.dbi.get_user_name_by_id(opponent)
        p this_match
        match_info << this_match
      end
      p match_info
    end
  end
end