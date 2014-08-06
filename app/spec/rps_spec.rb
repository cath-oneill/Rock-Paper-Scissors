require_relative '../lib/round.rb'

describe 'RPS_Logic' do
  describe 'Round' do
    before(:all) do
      @round1 = RPS_Logic::Round.new(5, 3)
    end
    
    describe ".initialize" do
      it "makes a new game with a match and round id assigned" do
        expect(@round1.match_id).to eq(5)
        expect(@round1.round_id).to eq(3)
      end

      it "starts the round without plays or a result" do
        expect(@round1.player_1_move).to be_nil
        expect(@round1.player_2_move).to be_nil
        expect(@round1.result).to be_nil
      end
    end

    describe ".player_1_move! and .player_2_move!" do
      it "assigns a value to @player_1_move or @player_2_move" do
        @round1.player_1_move!('r')
        @round1.player_1_move!('s')
        expect(@round1.player_1_move).to eq('r')  
        expect(@round1.player_2_move).to eq('s')
      end
    end

    describe ".result" do
      it "returns 0 for a tied game" do
        @round1.player_1_move!('r')
        @round1.player_2_move!('r')
        result = @round1.result
        expect(result).to eq(0)
      end

      it "returns a 1 if player 1 wins" do
        @round1.player_1_move!('r')
        @round1.player_2_move!('s')
        result = @round1.result
        expect(result).to eq(1)
      end

      it "returns a 2 if player 2 wins" do
        @round1.player_1_move!('p')
        @round1.player_2_move!('s')
        result = @round1.result
        expect(result).to eq(2)
      end

      it "returns nil if the round is not complete" do
        @round1.player_1_move!('r')
        result = @round1.result
        expect(result).to eq(nil)
      end
    end
  end
end