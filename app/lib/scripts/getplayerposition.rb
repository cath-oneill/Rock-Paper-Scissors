module RPS
  class GetPlayerPosition

    def self.run(user_id, match_id)
      match = RPS::DBI.dbi.get_match_by_id(match_id)

      if match.player_1_id == user_id
        return 1
      elsif match.player_2_id == user_id
        return 2
      end

    end
  end
end