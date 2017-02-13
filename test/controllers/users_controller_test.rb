require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.clean
    @user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    @other_user = User.create(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', password_confirmation: 'password', activated: true, activated_at: Time.zone.now)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user.id)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user.id), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user.id)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user.id), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user.id), params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user.id)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user.id)
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user.id)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user.id)
    assert_redirected_to login_url
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
