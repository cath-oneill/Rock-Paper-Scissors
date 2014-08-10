module RPS
  class GetMatchInfo
    def self.run(user)
      ##This script makes an array of hashes.  Each hash has information on one match for that user.  
      ##This array of hashes is passed to index.erb, where it is used to access all the 
      ##matches the player is involved in.
      match_info = []

      #In this primary loop, each  match's info is put into a hash.
      #Throughout this x refers to the match we are iterating through, and y refers to the rounds of that match.
      user.matches.each do |x|
        this_match = {}
      
        player_number = RPS::GetPlayerPosition.run(user.user_id, x.match_id)
      
        current_round_id = x.rounds.max_by { |y| y.round_id }.round_id
        current_round = x.rounds.max_by { |y| y.round_id }
      
        this_match[:match_id] = x.match_id
        this_match[:player_number] = player_number
        this_match[:completed] = x.completed
        this_match[:current_round] = current_round_id
      
        #determine whether the current player has already played on this round and is waiting for the other player
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
          this_match[:current_losses] = x.rounds.count{|y| y.result == 2}
        elsif player_number == 2
          opponent = x.player_1_id
          this_match[:current_losses] = x.rounds.count{|y| y.result == 1}
        end
      
        this_match[:opponent_id] = opponent
        this_match[:opponent_name] = RPS::DBI.dbi.get_user_name_by_id(opponent)

        #then the current hash is shoveled into the larger array
        match_info << this_match
      end #end of users.matches.each
      match_info
    end #end of .run
  end #end of class
end #end of module