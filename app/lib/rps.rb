module RPS
end

require_relative 'db/dbi.rb'

require_relative 'rps/user.rb'
require_relative 'rps/round.rb'
require_relative 'rps/match.rb'

require_relative 'scripts/signup.rb'
require_relative 'scripts/signin.rb'
require_relative 'scripts/getuserinfo.rb'
