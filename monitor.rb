require 'redis'

redis = Redis.new

redis.subscribe('equipment_status') do |on|
  puts 'ready'
  on.message do |channel, msg|
    puts msg
  end
end
