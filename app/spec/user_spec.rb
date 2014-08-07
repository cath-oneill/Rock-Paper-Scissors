require_relative '../lib/rps/user.rb'
require_relative '../lib/rps/match.rb'

describe 'RPS' do
  describe 'User' do
    before(:all) do
      @user1 = RPS::User.new('bob', 'bob@bob')
    end
    
    describe ".initialize" do
      it "makes a new user" do
        expect(@user1.name).to eq('bob')
        expect(@user1.email).to eq('bob@bob')
      end

      it "starts the user without password_digest, profile_pic, join_at, user_id and matches" do
        expect(@user1.user_id).to be_nil
        expect(@user1.profile_pic).to be_nil
        expect(@user1.profile_pic).to be_nil
        expect(@user1.join_at).to be_nil
        expect(@user1.matches).to eq([])
      end
      it "describes all matches played by the user" do 
        match1 = RPS::Match.new(10, 8)
        match2 = RPS::Match.new(10, 4, 4, 10.45, true, 4)
        @user1.matches << match1
        expect(@user1.matches).to eq([match1]) 
    end

    describe "#wins" do
      xit "describes all wins for the user" do
        match1 = RPS::Match.new(10, 8, 5, 10.30, true, 10)
        match2 = RPS::Match.new(10, 4, 4, 10.45, true, 4)
        @user1.matches << match1
        @user1.matches << match2
        expect(@user1.wins).to eq(1) 
      end
    end
    describe "#all_matches" do
      it "gives all matches " do
        expect(user1.all_matches).to eq(2) 
      end 
    end


    describe "#completed_matches" do
      it "returns all completed matches for the user" do
        expect(user1.completed_matches).to eq(2)
      end

      it "returns a 0 if there are no completed matches" do
        user2 = RPS::user.new('steve', 'stve@steve')
        expect(user1.completed_matches).to eq(0)
      end


    end
  end
end