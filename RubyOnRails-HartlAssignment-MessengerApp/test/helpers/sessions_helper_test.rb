require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:piet)
    #remembering makes session nil, but user is rememberd, this makes you go integration_test
    # the elsif part of the current_user function
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    # assert_equal <expected>, <actual>
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    # make sure he is not logged in
    assert_nil current_user
  end
end
