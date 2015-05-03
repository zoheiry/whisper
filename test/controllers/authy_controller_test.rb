require 'test_helper'

class AuthyControllerTest < ActionController::TestCase
  test "should get two-step" do
    get :two-step
    assert_response :success
  end

end
