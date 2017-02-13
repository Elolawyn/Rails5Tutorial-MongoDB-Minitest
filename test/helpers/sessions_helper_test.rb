require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    DatabaseCleaner.clean
    @user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
