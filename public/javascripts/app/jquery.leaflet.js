// depends on: underscore, leaflet

(function($) {

	var _options = {},
		_defaults = {
		    points: [],
		    afterInit: function() {},
		    markerClick: function() {}
		};
	
	$.fn.leaflet = function(opts) {
		if (0 == this.length) return this;
		
		_options = $.extend({}, _defaults, opts);
		var _elements = this;

		_elements.each(function() {
		    var map = L.map(this.id, {
    			fadeAnimation: false,
    			scrollWheelZoom: false
    		});
    		
    		new L.TileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png', {
    			attribution: 'Tiles courtesy <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img style="vertical-align: bottom; border: 0;" src="http://developer.mapquest.com/content/osm/mq_logo.png">',
    			subdomains: '1234'
    		}).addTo(map);

            var bounds = new L.LatLngBounds();
            _.each(_options.points, function(ll) {
                bounds.extend(L.latLng(ll));
                L.marker(ll, { 
                    title: ll[2],
                    click: function(e) {
                        document.location.href = ll[3];
                     }
                }).on('click', function(e) {
                    _options.markerClick(e)
                }).addTo(map);
            });
            map.fitBounds(bounds);

            $(this).addClass('initialized').data('map', map);
            
            _options.afterInit(map);
		});
		
		return this;
	}
	
})(jQuery);