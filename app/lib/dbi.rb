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

    def self.dbi
      @__db_instance ||= RPS.new
    end
  end

end