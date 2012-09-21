$(document).ready(function() {
	
	var search_teams = $('#search-team').data('teams');
	
	// $('#search-team').focus().autocomplete({
	// 	delay: 0,
	// 	source: function(r, cb) {
	// 		var teams = _.select(search_teams, function(team) {
	// 			return (team.label + " " + (team.altnames == null ? '' : team.altnames)).match(new RegExp(r.term, 'i')) != null; 
	// 		});
	// 		cb(teams);
	// 	},
	// 	select: function(e, ui) {
	// 		ui.item.the ? $('#search-team-definite-article').show() : $('#search-team-definite-article').hide();
	// 		document.location.hash = "q=" + encodeURIComponent(ui.item.id);
	// 		$('#venue-search-results').empty();
	// 		$('#venue-search-form').animate({
	// 			paddingTop: '0px'
	// 		}, {
	// 			duration: 92
	// 		});
	// 		$(this).blur().closest('#venue-search-form').data('team_id', ui.item.id).data('team_name', ui.item.label);
	// 		ui.item.the ? $('#search-team-definite-article').show() : $('#search-team-definite-article').hide();
	// 		$.getJSON('/venues/search.js?' + $.param($(this).closest('#venue-search-form').data()) + '&callback=?', function(results) {
	// 			if (results.length > 0) {
	// 				_.each(results, function(r) {
	// 					$('#venue-search-results').append(_.template($('.template#venues-show').html(), { "show": r }));
	// 				});
	// 			} else {
	// 				$('#venue-search-results').append('<li class="no-results">No results</li>');
	// 			}
	// 		});
	// 	}
	// });
	
	
});
