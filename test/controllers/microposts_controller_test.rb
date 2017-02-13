require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.clean
    @user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    @micropost = @user.microposts.create(content: "I just ate an orange!", created_at: 10.minutes.ago )
    @archer = User.create(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', password_confirmation: 'password', activated: true, activated_at: Time.zone.now)
    @micropost_archer = @archer.microposts.create(content: "Oh, is that what you want? Because that's how you get ants!", created_at: 2.years.ago )
  end

  test "should redirect create when not logged in" do
    assert_no_difference '@user.microposts.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference '@user.microposts.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    assert_no_difference '@archer.microposts.count' do
      delete micropost_path(@micropost_archer)
    end
    assert_redirected_to root_url
  end

  def teardown
    DatabaseCleaner.clean
  end
end
