require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    DatabaseCleaner.clean
    @admin = User.create(name: "Michael Example", email: "michael@example.com", password: 'password', password_confirmation: 'password', admin: true, activated: true, activated_at: Time.zone.now)
    @non_admin = User.create(name: "Sterling Archer", email: "duchess@example.gov", password: 'password', password_confirmation: 'password', activated: true, activated_at: Time.zone.now)
    50.times do |count|
      User.create(name: "User #{count}", email: "ej#{count}@example.gov", password: 'password', password_confirmation: 'password', activated: true, activated_at: Time.zone.now)
    end
  end

  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
