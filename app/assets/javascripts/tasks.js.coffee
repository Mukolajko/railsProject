# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#task_file").fileupload
		dataType: 'json'
		add: (e, data) ->
			types = /(\.|\/)(gif|jpe?g|png)$/i
			file = data.files[0]
			if types.test(file.type)
				$(".new_files").append("<p>" +file.name+ "</p>")
				data.submit()
			else
				alert("Wrong format")