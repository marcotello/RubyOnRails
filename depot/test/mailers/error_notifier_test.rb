require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "raised" do
    mail = ErrorNotifier.raised("Attempt to access invalid cart with the cart_id = 243233", "carts", "show")
    assert_equal "Pragmatic Store Error Raised", mail.subject
    assert_equal ["marcotello@grupovidanta.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "error", mail.body.encoded
  end

end
