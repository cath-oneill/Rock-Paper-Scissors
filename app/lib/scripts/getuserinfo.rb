module RPS_Scripts
  class GetUserInfo
    def self.run(params)
        current_user = DBI.dbi.get_user_by_email(session['rps'])
        current_user.matches = DBI.dbi.get_matches_by_player(current_user.user_id)
        current_user.matches each do |m|
          match.rounds = DBI.dbi.get_rounds_by_match_id(m.match_id)
        end
        session['rps'] ? current_user : nil
    end
  end
end