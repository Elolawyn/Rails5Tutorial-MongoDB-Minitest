require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    DatabaseCleaner.clean
    @user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    @micropost_2 = @user.microposts.create(content: "Lorem ipsum", created_at: Time.zone.now - 2.days)
    @micropost_1 = @user.microposts.create(content: "Lorem ipsum", created_at: Time.zone.now)
  end

  test "should be valid" do
    assert @micropost_2.valid?
  end

  test "content should be present" do
    @micropost_2.content = "   "
    assert_not @micropost_2.valid?
  end

  test "content should be at most 140 characters" do
    @micropost_2.content = "a" * 141
    assert_not @micropost_2.valid?
  end

  test "order should be most recent first" do
    assert_equal @user.microposts.scoped.first, @micropost_1 # PONED SCOPED PARA APLICAR EL DEFAULT SCOPE :O
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
