# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
adminPasswordToggle = ($element) ->
	if $element.val().length > 0
		$('#admin_password_container').css('display','inline-block')
	else
		$('#admin_password_container').css('display','none')

adminPasswordAddEventsOnLoad = ->
	$password = $('#admin_password_container').parent().find('#user_password') 

	$passwordConfirmation = $('#admin_password_container').parent().find('#user_password_confirmation') 	
	
	$password.keypress ->
		adminPasswordToggle($password)

	$password.focusout ->
		adminPasswordToggle($password)

	$passwordConfirmation.keypress ->
		adminPasswordToggle($passwordConfirmation)

	$passwordConfirmation.focusout ->
		adminPasswordToggle($passwordConfirmation)

$(document).on "ready", adminPasswordAddEventsOnLoad

$(document).on "page:load", adminPasswordAddEventsOnLoad
