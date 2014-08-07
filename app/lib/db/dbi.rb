require 'pg'
require 'pry-byebug'

module RPS
  class DBI
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'rps')
      build_tables
    end    

    # these methods create the tables in your db if they
    # dont already exist
    def build_tables
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS users(
          user_id serial NOT NULL PRIMARY KEY,
          name text,
          password_digest text,
          email text,
          join_at timestamp NOT NULL DEFAULT current_timestamp,
          profile_pic text
        )])
  
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS matches(
          match_id serial NOT NULL PRIMARY KEY,
          player_1_id int references users(user_id),
          player_2_id int references users(user_id),
          winner_id int references users(user_id),
          start_at timestamp NOT NULL DEFAULT current_timestamp,
          completed boolean DEFAULT false
        )])
  
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS rounds(
          round_id int,
          match_id int references matches(match_id),
          player_1_move char(1),
          player_2_move char(1),
          result int,
          start_at timestamp NOT NULL DEFAULT current_timestamp
        )])
    end
    #
    # Method to create a user record
    #
    def save_user(user)
      @db.exec(%q[
        INSERT INTO users (name, email, password_digest, profile_pic)
        VALUES ($1, $2, $3, $4);
      ], [user.name,  user.email, user.password_digest, user.profile_pic])
    end


    def build_user(data)
     RPS::User.new(data["name"], data["email"], data["password_digest"], data["profile_pic"], data["join_at"], data["user_id"])
    end
 

    ## FOR USE WHEN LOGGING IN
    def get_user_by_email(this_email)
      response = @db.exec("SELECT * FROM users WHERE email = '#{this_email}'")
      user_data = response.first
      user_data ? build_user(user_data) : nil
    end

    def user_exists?(this_email)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE email = '#{this_email}';
      ])
      if result.count > 1
        true
      else
        false
      end
    end

    ## FOR USE IN GAME PLAY
    def get_user_by_id(this_id)
      response = @db.exec("SELECT * FROM users WHERE user_id = '#{this_id}'")
      response.first
    end

    #FOR USE IN PLAYERS PAGE
    def get_all_users
      response = @db.exec("SELECT name user_id profile_pic FROM users")
    end

  # Method to create a match record
    #
    def save_match(player_1_id, player_2_id)
      @db.exec(%q[
        INSERT INTO users (player_1_id, player_2_id)
        VALUES ($1, $2);
      ], [player_1_id, player_2_id])
    end

    def build_match(data)
      RPS::Match.new(data["player_1_id"], data["player_2_id"], data["match_id"], data["start_at"], data["completed"], data["winner_id"])
    end
    
    def get_match_by_id(this_id)
      response = @db.exec("SELECT * FROM matches WHERE match_id = '#{this_id}'")
      build_match(response.first)
    end

    def get_matches_by_player(user_id)
      response = @db.exec("SELECT * FROM matches WHERE player_1_id = '#{user_id}' OR player_2_id = '#{user_id}'")
      response.map {|row| build_match(row)}
    end

    def get_matches_by_winner(user_id)
      response = @db.exec("SELECT * FROM matches WHERE winner_id = '#{user_id}'")
      response.map {|row| build_match(row)}
    end

    def get_all_matches
      response = @db.exec("SELECT * FROM matches")
      response.map {|row| build_match(row)}
    end


  # Method to create a round record
    def save_round(round_id, match_id)
      @db.exec(%q[
        INSERT INTO rounds (round_id, match_id)
        VALUES ($1, $2);
      ], [round_id, match_id])
    end

    def build_round(data)
      RPS::Round.new(data["match_id"], data["round_id"], data["player_1_move"], data["player_2_move"], data["result"])
    end

    def get_round_by_id(this_id)
      response = @db.exec("SELECT * FROM rounds WHERE round_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    #used by 
    def get_rounds_by_match_id(this_id)
      response = @db.exec("SELECT * FROM rounds WHERE match_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_all_rounds
      response = @db.exec("SELECT * FROM rounds")
      response.map {|row| build_user(row)}
    end
  
    def self.dbi
      @__db_instance ||= DBI.new
    end
  end

end