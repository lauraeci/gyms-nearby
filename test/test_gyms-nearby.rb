# encoding: UTF-8
require_relative 'test_helper'

class TestGymsNearby < MiniTest::Test

  def test_new
    gym = GymsNearby.new(lat: 37.402079, long: -122.108896)
    assert_equal '37.402079', gym.lat.to_s
    assert_equal '-122.108896', gym.long.to_s
  end

  def test_within_radius
    VCR.use_cassette("nearbysearch") do
      # Example result:
      # res = {
      #   "html_attributions" => [],
      #   "results" => [
      #     {
      #       "geometry" => {
      #         "location" => {
      #           "lat" => 37.402537,
      #           "lng" => -122.1095753
      #         },
      #         "viewport" => {
      #           "northeast" => {
      #             "lat" => 37.4038859802915,
      #             "lng" => -122.1082263197085
      #           },
      #           "southwest" => {
      #             "lat" => 37.4011880197085,
      #             "lng" => -122.1109242802915
      #           }
      #         }
      #       },
      #       "icon" => "https=>//maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png",
      #       "id" => "bc642e82d904f789d534d5eff0f94b824d9215a0",
      #       "name" => "24 Hour Fitness",
      #       "opening_hours" => {
      #         "exceptional_date" => [],
      #         "open_now" => true,
      #         "weekday_text" => []
      #       },
      #       "place_id" => "ChIJxevLLZmwj4ARkA3OHUAuby0",
      #       "rating" => 2.8,
      #       "reference" => "CmRRAAAAtalFBSTHJqdjeRllbyLGsbfyrSZwoOPmbIyXOttp9db1wKKCAoiv_uze76sNYVGVxMP5hDtpmQEXqp712TMRji9tEIiBuTmc44Sv52FTroWU6fdbw-cS9KajZ871aiBcEhB_aNTwMUXGaSd-vTomrnpOGhRm_FBVyemC1kUNIvQn-rzwfTSQFw",
      #       "scope" => "GOOGLE",
      #       "types" => ["gym", "health", "point_of_interest", "establishment"],
      #       "vicinity" => "550 Showers Drive, Mountain View"
      #     }
      #   ],
      #   "status" => "OK"
      # }


      api_key = " AIzaSyD_4PGQ5vEroNxwiy5OXlVH8X_G7hXcbL6 "
      response = GymsNearby.within_radius(lat: 37.402079, long: -122.108896, radius: 800, api_key: api_key)
      assert_match /24 Hour Fitness/, response.body
    end
  end
end