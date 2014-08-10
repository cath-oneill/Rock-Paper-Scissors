module RPS
  class CreateNewMatch
    def self.run(user_id, opponent_id)
        this_match = RPS::Match.new(user_id, opponent_id)
        this_match = RPS::DBI.dbi.save_match(this_match)
        this_match = RPS::DBI.dbi.build_match(this_match.first)
        this_match_id = this_match.match_id

        this_round = RPS::Round.new(this_match_id, 1)
        this_round = RPS::DBI.dbi.save_round(this_round)

        {
          match_id: this_match_id,
          round_id: 1,
          player_position: 1
        }
    end
  end
end