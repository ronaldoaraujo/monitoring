require 'redis'
require 'json'

class OnlineAssigner
  extend Forwardable

  DEFAULT_EXPIRATION_TIME = 28860

  def_delegators :@data, :equipment_id, :t1, :t2, :ttl

  def initialize(data)
    @data = OpenStruct.new(data)
  end

  def self.call(data)
    new(data).call
  end

  def call
    return unless data

    key = "equipment_#{equipment_id}"
    was_online = redis.keys(key).any?
    redis.set(key, 0, ex: expiration_time)

    return if was_online

    redis.publish 'equipment_status', { equipment_id: equipment_id, status: 'online' }.to_json
  end

  private

  def expiration_time
    ttl || DEFAULT_EXPIRATION_TIME
  end

  def redis
    @redis ||= Redis.new
  end

  attr_accessor :data
end
