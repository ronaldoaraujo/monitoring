require 'redis'
require_relative 'offline_assigner.rb'

redis = Redis.new
redis.config('set', 'notify-keyspace-events', 'Ex')
redis.psubscribe('__keyevent@0__:expired') do |on|
  puts 'ready'
  on.pmessage do |_pattern, _channel, message|
    puts 'message received'

    OfflineAssigner.(message)
  end
end
