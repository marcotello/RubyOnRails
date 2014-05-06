# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#$(document).on "ready", ->
#	$('.store .entry > img').mousedown ->
#		$(this).parent().find(':submit').click()

allowAddProductsByClickOnImages = ->
	$('.store .entry > img').mousedown ->
		$(this).parent().find(':submit').click()
		
$(document).on "ready", allowAddProductsByClickOnImages

$(document).on "page:load", allowAddProductsByClickOnImages

