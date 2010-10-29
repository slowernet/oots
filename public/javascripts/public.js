$(document).ready(function() {
	_.templateSettings = { interpolate : /\#\{(.+?)\}/g };	// #{} style

	// ul.select /////////////////////////////////////////

	// open on click selected, close on reclick
	$('ul.select li.selected a').live('click', function(e) {
		e.preventDefault();	
		$(this).parents('ul.select').toggleClass('open');
	});
	// close on click off
	$(document).click(function(e) {
		if(!$(e.target).is('ul.select li a')) $('ul.select').removeClass('open');
	});
	// update selection
	$('ul.select.open li a').live('click', function(e) {
		e.preventDefault();	
		$(this).parent('li').addClass('selected').siblings('li').removeClass('selected').parents('ul.select').removeClass('open').data('strength', $(this).html());
	});
	
	// venue search /////////////////////////////////////////

	if ((c = $.cookies.get('search-city')) && c.lat) {
		$('#search-city').html(c.city).addClass('preliminary').closest('#search-form').data('city', c.city).data('lat', c.lat).data('lon', c.lon);
	}
	
	$('#search-team').focus().autocomplete({ 
		source: function(r, cb) {
			var teams = _.select($('#search-team').data('teams'), function(team) {
				return (team.label + " " + (team.altnames == null ? '' : team.altnames)).match(new RegExp(r.term, 'i')) != null; 
			});
			cb(teams);
		},
		select: function(e, ui) {
			$(this).blur().closest('#search-form').data('team_id', ui.item.id).data('team_name', ui.item.label);
			ui.item.definite_article ? $('#search-team-definite-article').show() : $('#search-team-definite-article').hide();
			$.getJSON('/venues/search.js?' + $.param($(this).closest('#search-form').data()) + '&callback=?', function() {
			});
		}
	});
	
	if ($('#search-city').length && navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			var c = position.coords;
			$.ajax({
				url: "http://query.yahooapis.com/v1/public/yql",
				dataType: "jsonp",
				data: {
					q: "select * from geo.placefinder where text='" + c.latitude + " " + c.longitude + "' and gflags='R'",
					format: 'json',
					callback: '?'
				},
				success: function(d) {
					var r = d.query.results['Result'];
					$.cookies.set('search-city', { city: r.city, lat: c.latitude, lon: c.longitude });
					$('#search-city').html(r.city).removeClass('preliminary').closest('#search-form').data('city', r.city).data('lat', c.latitude).data('lon', c.longitude);
				}				
			});
		}, function(m) {
			console.log(m);
		});
	}

	// venue edit /////////////////////////////////////////
	
	$('#venue-search-location').change(function() {
		var $that = $(this);
		$.ajax({
			url: "http://query.yahooapis.com/v1/public/yql",
			dataType: "jsonp",
			data: {
				q: "select * from geo.placefinder where text='" + $(this).val() + "'",
				format: 'json',
				callback: '?'
			},
			success: function(d) {
				var r = d.query.results['Result'];
				$that.closest('.form').data('lat', r.latitude).data('lon', r.longitude);
			}
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
					// massage inconsistently structured 4sq API results
					var venues = d.query.results.venues;
					venues = _.isArray(venues.group) ? venues.group : Array(venues.group);
					venues = _.select(venues, function(g) { return(g.type == 'Matching Places'); } ).shift().venue; 
					venues = _.isArray(venues) ? venues : Array(venues);
					$('#venue-search-name').data('venues', venues);
					venues = _.map(venues, function(v) { return { label: v.name + " @ " + v.address, id: v.id, distance: parseInt(v.distance) } }).sort(function(a,b) { return((a.distance < b.distance) ? -1 : 1); });
					cb(venues); 
				}
			});
		},
		delay: 500,
		minLength: 2,
		select: function(e, ui) {
			var venue = _.select($('#venue-search-name').data('venues'), function(v) { return (v.id == ui.item.id); }).shift();

			// check whether we have this venue already
			$.getJSON('/venues/search.js', { foursquare_id: venue.id }, function(d) {
				console.log(d);
				if (d.length > 0) { document.location.href = '/venues/f/' + venue.id; }
			});
			
			$('#venue-pre-edit-search').hide();
			$('#venue-edit').fadeIn();
			
			$('#venue_name').val(venue['name']);
			$.each(['address', 'city', 'state', 'zip', 'crossstreet', 'phone', 'twitter'], function(i, v) {
				jQuery('#venue_' + v).val(venue[v]);
			});
			jQuery('#venue_foursquare_id').val(venue['id']);
		}
	});

	// bond edit /////////////////////////////////////////

	$('#bond-note').elastic();
	$('#open-add-bond').click(function() {
		$(this).hide();
		$('#add-bond').toggle(); 
		return false;
	});
	
	$('#bond-team-name').autocomplete({
		source: function(r, cb) {
			var teams = _.select($('#bond-team-name').data('teams'), function(team) {
				return (team.label + " " + (team.altnames == null ? '' : team.altnames)).match(new RegExp(r.term, 'i')) != null; 
			});
			cb(teams);
		},
		select: function(e, ui) {
		}		
	});
});
