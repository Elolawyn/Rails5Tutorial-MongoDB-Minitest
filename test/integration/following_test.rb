require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.clean
    @user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    @other = User.create(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', password_confirmation: 'password', activated: true, activated_at: Time.zone.now)
    log_in_as(@user)
  end

  test "following page" do
    @user.follow(@other)
    @other.follow(@user)
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    @user.follow(@other)
    @other.follow(@user)
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow a user the standard way" do
    assert_difference '@user.reload.following.count', 1 do
      post follow_path, params: { user_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.reload.following.count', 1 do
      post follow_path, xhr: true, params: { user_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    assert_difference '@user.reload.following.count', -1 do
      delete unfollow_path, params: { user_id: @other.id }
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    assert_difference '@user.reload.following.count', -1 do
      delete unfollow_path, xhr: true, params: { user_id: @other.id }
    end
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
