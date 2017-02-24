module GymsNearby
  require "gyms-nearby/version"
  require "gyms-nearby/gyms"

  def self.new(lat:, long:, **config)
    GymsNearby::Gyms.new(lat, long, config)
  end

  def self.within_radius(lat:, long:, radius:, api_key:)
    GymsNearby.new(lat: lat, long: long).within_radius(radius: radius, api_key: api_key, type: nil)
  end
end
