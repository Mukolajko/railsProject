# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#task_file").fileupload
		dataType: 'json'
		add: (e, data) ->
			file = data.files[0]
			$(".new_files").append("<p>" +file.name+ "</p>")
			data.submit()