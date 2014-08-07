require_relative '../lib/rps/match.rb'

describe 'RPS' do
  describe 'Match' do
    before(:all) do
      @match1 = RPS::Match.new(10, 8)
    end
    
    describe ".initialize" do
      it "makes a new match with player 1 and player 2 ids" do
        expect(@match1.player_1_id).to eq(10)
        expect(@match1.player_2_id).to eq(8)
      end

      it "starts the match without match_id, or completed, winner_id" do
        expect(@match1.match_id).to be_nil
        expect(@match1.completed).to be_nil
        expect(@match1.winner_id).to be_nil
      end
    end

    describe "#winner" do
      it "describes player2 that wins the match if player is 2 " do
        @match1.winner(2)
        expect(@match1.winner_id).to eq(8) 
      end
    end
    describe "#winner" do
      it "gives nil if player is 4 " do
        match2 = RPS::Match.new(10, 8)
        match2.winner(4)
        expect(match2.winner_id).to be_nil 
      end 
    end
    describe "#completed!" do
      it "returns true" do
        result = @match1.completed!
        expect(result).to eq(false)
      end
      xit "returns nil if the round is not complete" do
        @round1.player_1_move!('r')
        result = @round1.result
        expect(result).to eq(nil)
      end
    end

    describe "#new_round_id" do

    end 


  end
end