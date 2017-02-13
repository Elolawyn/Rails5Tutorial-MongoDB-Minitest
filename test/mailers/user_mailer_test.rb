require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    DatabaseCleaner.clean
  end
  
  test "account_activation" do
    user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "password_reset" do
    DatabaseCleaner.clean
    user = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
