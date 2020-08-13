require 'redis'
require 'json'

class OfflineAssigner
  def initialize(key)
    @key = key
  end

  def self.call(key)
    new(key).call
  end

  def call
    redis.publish 'equipment_status', { equipment_id: equipment_id, status: 'offline' }.to_json
  end

  private

  def equipment_id
    @equipment_id ||= key.gsub(/equipment_/, '')
  end

  def redis
    @redis ||= Redis.new
  end

  attr_reader :key
end
