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
        this_match[:match_id] = x.match_id
        this_match[:player_number] = player_number
        this_match[:completed] = x.completed
        this_match[:current_round] = x.rounds.last.round_id
        this_match[:current_wins] = x.rounds.select{|x| x.round_info[:result] == player_number}.length
        this_match[:current_ties] = x.rounds.select{|x| x.round_info[:result] == 0}.length
        if player_number == 1
          opponent = x.player_2_id
          this_match[:current_losses] = x.rounds.select{|x| x.round_info[:result] ==2}.length
        elsif player_number == 2
          opponent = this_match.player_1_id
          this_match[:current_losses] = x.rounds.select{|x| x.round_info[:result] == 1}.length
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