$(document).ready(function() {
	_.templateSettings = { interpolate : /\#\{(.+?)\}/g };

	$('#search-team').focus().autocomplete({ 
		source: $('#search-team').data('teams'),
		select: function(e, ui) {
			$(this).blur().closest('#search-form').data('team_id', ui.item.id).data('team_name', ui.item.label);
			ui.item.definite_article ? $('#search-team-definite-article').show() : $('#search-team-definite-article').hide();
			$.getJSON('/venues/search.js?' + $.param($(this).closest('#search-form').data()) + '&callback=?', function() {
				
			});
		}
	});
	
	if ((c = $.cookies.get('search-city')) && c.lat) {
		$('#search-city').html(c.city).addClass('preliminary').closest('#search-form').data('city', c.city).data('lat', c.lat).data('lon', c.lon);
	}
	
	if ($('#search-city').length && navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var c = position.coords;
			$.yql("select * from geo.placefinder where text='" + c.latitude + " " + c.longitude + "' and gflags='R'", 
				function(data) {
					var r = data.query.results['Result'];
					$.cookies.set('search-city', { city: r.city, lat: c.latitude, lon: c.longitude });
					$('#search-city').html(r.city).removeClass('preliminary').closest('#search-form').data('city', r.city).data('lat', c.latitude).data('lon', c.longitude);
				}
			);
		}, function(m) {
			console.log(m);
		});
	}

	$('#venue-search-location').change(function() {
		var $that = $(this);
		$.yql("select * from geo.placefinder where text='" +$(this).val() + "' and gflags=''", function(d) {
			var r = d.query.results['Result'];
			$that.closest('.form').data('lat', r.latitude).data('lon', r.longitude);
		});
		
	});
	
	$('#venue-search-name').autocomplete({
		source: function(r, cb) {
			$.ajax({
				url: "http://query.yahooapis.com/v1/public/yql",
				dataType: "jsonp",
				data: {
					q: 'select * from foursquare.venues where q="' + r.term + '" and geolat="' + $('#venue-search-name').closest('.form').data('lat') + '" and geolong="' + $('#venue-search-name').closest('.form').data('lon') + '"',
					env: 'store://datatables.org/alltableswithkeys',
					format: 'json',
					callback: '?'
				},
				success: function(d) {
					var venues = d.query.results.venues.group.venue; venues = _.isArray(venues) ? venues : Array(venues);
					venues = _.map(venues, function(v) { return { label: v.name + ": " + v.address, id: v.id } });
					cb(venues); 
				}
			});
		},
		delay: 500,
		minLength: 2,
		select: function(e, ui) {
			$(this).blur().closest('#search-form').data('team_id', ui.item.id).data('team_name', ui.item.label);
			ui.item.definite_article ? $('#search-team-definite-article').show() : $('#search-team-definite-article').hide();
			$.getJSON('/venues/search.js?' + $.param($(this).closest('#search-form').data()) + '&callback=?', function() {
				
			});
		}
	});

	// $('#venue-search-name').change(function() {
	// 	var $that = $(this);
	// 	$.yql("use 'http://www.datatables.org/foursquare/foursquare.venues.xml' as foursquare.venues; select * from foursquare.venues where q='" + $that.val() + "' and geolat='" + $that.closest('.form').data('lat') + "' and geolong='" + $that.closest('.form').data('lon') + "'", function(d) {
	// 		var venues = d.query.results.venues.group.venue; venues = _.isArray(venues) ? venues : Array(venues);
	// 		_.each(venues, function(v) {
	// 			console.log(v);
	// 			$('#venue-search-results').prepend($.trim(_.template($('.template#search-venue').html(), v)));
	// 		});
	// 	});			
	// });
});
