require 'test_helper'

class UserTest < ActiveSupport::TestCase
	fixtures :users
  # test "the truth" do
  #   assert true
  # end

  test "Un suceessful user authentication" do
  	user = User.authenticate("Jordy", "password")
  	assert user.blank?
  end

  test "Suceessful user authentication" do
  	user = User.authenticate("dave", "secret")
  	assert user.present?
  end

  test "Leave always one admin in the database" do
  	users = User.all
  	begin 
  		users.each do |user|
  			user.destroy
  		end
  	rescue StandardError => e
  		assert_equal "Can't delete last user", e.message
  	end
  end
end
