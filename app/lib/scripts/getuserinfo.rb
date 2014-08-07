module RPS
  class GetUserInfo
    def self.run(user_id)
        current_user = RPS::DBI.dbi.get_user_by_id(user_id)
        RPS::DBI.dbi.get_matches_by_player(current_user.user_id).each do |m|
          current_user.matches << m
        end
        current_user.matches.each do |m|
          RPS::DBI.dbi.get_rounds_by_match_id(m.match_id).each do |r|
            m.rounds << r 
          end
        end
        current_user
    end
  end
end