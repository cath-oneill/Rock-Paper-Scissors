module RPS
  class CreateNewMatch
    def self.run(user_id, opponent_id)
        this_match = RPS::Match.new(user_id, opponent_id)
        response = RPS::DBI.dbi.save_match(this_match)
        this_match = RPS::DBI.dbi.build_match(response.first)
        this_match_id = this_match.match_id

        this_round = RPS::Round.new(this_match_id, 1)
        this_round = RPS::DBI.dbi.save_round(this_round)

        opponent = RPS::DBI.dbi.get_name_and_email(opponent_id)

        Pony.mail(
          :to => opponent[:email],   
          :via => :smtp,
          :via_options => {
            :address              => 'smtp.gmail.com',
            :port                 => '587',
            :enable_starttls_auto => true,
            :user_name            => 'rps.makersquare',
            :password             => 'rockpaperscissors',
            :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
            :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
            },
          :from => 'rps.makersquare@gmail.com', 
          :subject => 'CHALLENGE: Rock, Paper, Scissors', 
          :body => "Dear #{opponent[:name]}, \nYou have been challenged to a new game of Rock, Paper, Scissors.  Log on now to play! \n--the RPS team "
          )

        {
          match_id: this_match_id,
          round_id: 1,
          player_position: 1
        }
    end
  end
end