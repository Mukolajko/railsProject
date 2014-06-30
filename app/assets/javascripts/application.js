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
//= require jquery.ui.draggable
//= require jquery.ui.sortable
//= require jquery-tablesorter
//= require_tree .


$(document).ready(function(){
	$("#add_users").click(function(){
		$(".hidden").slideToggle();
	});
});

$(function(){
	// sort and load user tasks
	$("#tasks").on('click', '.sort > a, .pagination > a', function(){
		$("#flash_notice").remove();
		$.getScript(this.href);
		return false;
	});
	$("#default").on('click', function(){
		$("#flash_notice").remove();
		$.getScript(this.href);
		return false;
	});
	$("#drugndrop").on('click', function(){
		window.location.href = "/dragdrop"
	});
	//table sorter for all tasks
	$("#task_table").tablesorter({
		theme: 'blue',
		widgets: ["zebra"]
	});

	$(".drop").sortable({
		connectWith: ".drop",
		receive: function (e, ui) {
			var elem = ui.item.html()
			var from = ui.sender.closest("section").attr("id");
			var to = ui.item.closest("section").attr("id");
			var url = "/dragdrop/" + elem + "/" + from + "/" + to
			if (ui.sender.closest("section").next("section").attr("id") == to || ui.item.closest("section").next("section").attr("id") == from) {
				$.ajax({
					type: "GET",
					url: url,
					error: function(responce) {
						$(".drop").sortable("cancel");	
					}
				});
			}
			else {
				$(".drop").sortable("cancel");	
			}			
		}
	});
});
