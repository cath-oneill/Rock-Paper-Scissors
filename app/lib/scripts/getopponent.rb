module RPS
  class GetOpponent

    def self.run(user_id, match_id)
      this_match = RPS::DBI.dbi.get_match_by_id(match_id)
      if user_id == this_match.player_1_id
        opponent_id = this_match.player_2_id
      elsif user_id == this_match.player_2_id
        opponent_id = this_match.player_1_id
      end

      opponent = RPS::DBI.dbi.get_user_by_id(opponent_id)
      opponent.name
    end
  end
end