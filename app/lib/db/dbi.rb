require 'pg'
require 'pry-byebug'

module DBI
  class RPS
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'rps')
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
    def save_user(name, password_digest, email, profile_pic)
      @db.exec(%q[
        INSERT INTO users (name, password_digest, email, profile_pic)
        VALUES ($1, $2, $3, $4);
      ], [name, password_digest, email, profile_pic])
    end


    def build_user(data)
     User.new(data["name"], data["password_digest"], data["email"], data["profile_pic"], data["join_at"], data["user_id"])
    end
 


    def get_user_by_email(this_email)
      response = @db.exec("SELECT * FROM users WHERE email = '#{this_email}'")
      response.map {|row| build_user(row)}
    end

    def get_user_by_id(this_id)
      response = @db.exec("SELECT * FROM users WHERE user_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_all_users
      response = @db.exec("SELECT * FROM users")
      response.map {|row| build_user(row)}
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
      Match.new(data["player_1_id"], data["player_2_id"], data["match_id"], data["start_at"], data["completed"], data["winner_id"])
    end
    
    def get_matches_by_id(this_id)
      response = @db.exec("SELECT * FROM matches WHERE match_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_finished_matches_by_id(this_id)
      response = @db.exec("SELECT * FROM matches WHERE match_id = '#{this_id}' AND completed = 't'")
      response.map {|row| build_user(row)}
    end

    def get_unfinished_matches_by_id(this_id)
      response = @db.exec("SELECT * FROM matches WHERE match_id = '#{this_id}' AND completed = 'f'")
      response.map {|row| build_user(row)}
    end

    def get_match_by_player(this_id)
      response = @db.exec("SELECT * FROM matches WHERE player_1_id = '#{this_id}' OR player_2_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_match_by_winner(this_id)
      response = @db.exec("SELECT * FROM matches WHERE winner_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_all_matches
      response = @db.exec("SELECT * FROM matches")
      response.map {|row| build_user(row)}
    end


  # Method to create a round record
    def save_round(round_id, match_id)
      @db.exec(%q[
        INSERT INTO rounds (round_id, match_id)
        VALUES ($1, $2);
      ], [round_id, match_id])
    end

    def build_round(data)
      Round.new(data["match_id"], data["round_id"], data["player_1_move"], data["player_2_move"], data["result"])
    end

    def get_round_by_id(this_id)
      response = @db.exec("SELECT * FROM rounds WHERE round_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_round_by_match_id(this_id)
      response = @db.exec("SELECT * FROM rounds WHERE match_id = '#{this_id}'")
      response.map {|row| build_user(row)}
    end

    def get_all_rounds
      response = @db.exec("SELECT * FROM rounds")
      response.map {|row| build_user(row)}
    end
  
    def self.dbi
      @__db_instance ||= RPS.new
    end
  end

end