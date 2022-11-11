require 'test_helper'

class WallsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get walls_index_url
    assert_response :success
  end

end
