require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  test "create should require logged-in user" do
    post follow_path, params: { user_id: '334' }
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    delete unfollow_path, params: { user_id: '334' }
    assert_redirected_to login_url
  end
end
