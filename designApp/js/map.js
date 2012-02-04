
$(function() {
    var geocoder = new google.maps.Geocoder()
    var $map = $("#mapInterface")
    var map;

    function drawMap(element) {
        $map = $(elemeet)
        map = new google.maps.Map($map.get(0), {
            center: new google.maps.LatLng(38.203655, -99.228516),
            zoom: 4,
            minZoom: 4,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        })
    }

    function setMap(mris) {
        for (var i = 0; i < mris.length; i++) {
            var mri = mris[i]

            var marker = new google.maps.Marker({
                map: map,
                position: latLngForMri(mri)
            })
        }
    }
				
    // returns a location object in lat/lon format
    function locationForAddress(address, cb) {
        geocoder.geocode( { 'address': address}, function(results, status) {
            if (status != google.maps.GeocoderStatus.OK) 
                return console.log("Geocode was not successful for the following reason: " + status);

            var loc = results[0].geometry.location

            cb({lat: loc.lat(), lng: loc.lng()})
        });

    }

    function latLngForMri(mri) {
        // new google.maps.LatLng(lat:number, lng:number, noWrap?:boolean)
        return new google.maps.LatLng(mri.location.lat, mri.location.lng)
    }

    // allow other modules to call this (the data module)
    mh.map = {
        drawMap: drawMap,
        setMap: setMap,
        locationForAddress: locationForAddress
    }
})





// map.setCenter(results[0].geometry.location);
