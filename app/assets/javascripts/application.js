// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.dialog
//= require jquery.ui.effect-explode
//= require jquery.ui.effect-blind
//= require twitter/bootstrap
//= require jquery.ui.sortable
//= require_tree .

$(function(){

	$("#add_users").click(function(){
		$(".hide").slideToggle();
	});
	// sort and load user tasks
	$("#all_tasks, #tasks").on('click', '.sort > a, .pagination > a', function(){
		$("#flash_notice").remove();
		$.getScript(this.href);
		return false;
	});
	$(".drop").sortable({
		connectWith: ".drop",
		receive: function (e, ui) {
			var id = ui.item.attr("id").split("_")[1];
			var status = ui.item.closest(".thumbnail").attr("id");
			var url = "tasks/" + id + "/" + status
			$.ajax({
				type: "GET",
				url: url,
				dataType: 'script',
				success: function(response) {
					if (response == "false") {
						$(".drop").sortable("cancel");	
					}
				},
				error: function(response) {
					$(".drop").sortable("cancel");	
				}
			});		
		}
	});

	$(".table").on('click', 'span',function(){
		var taskname = $(this).parent().find("a").attr("class");
		var modalWindow = $(document.createElement('div'))
		modalWindow.attr('title', "Show users in task")
		$.ajax({
			url: "/modal/" + taskname,
			success: function(response) {
				modalWindow.append(response)
			}
		})
		modalWindow.dialog({
			show: {
				effect: "blind",
				duration: 1000
			},
			hide: {
				effect: "explode",
				duration: 1000
			}
		}).dialog("open")
	});
});