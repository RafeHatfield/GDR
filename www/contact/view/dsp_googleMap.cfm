<cfoutput>

	<cfsaveContent variable="htmlText">
		<table class="googleTable"><tr><td><h1>Bali Sentosa</h1><br /><h2 class="googleH2"><b>Jl. Pura Telaga Waja, Petitenget, Seminyak, Bali, Indonesia 80361</h2></p></td></tr><tr><td><img src="assets/images/upload/page1.jpg" width="120" class="content_image"><div class="googleFont">Sentosa Private Villa and Spa Bali Resort is an exclusive ensemble of 38 luxurious villas in Bali; all set in idyllic landscaped gardens with private pools.<br /><br /><a href="index.cfm?fuseaction=contact.contactDetails&page=contact-us">Click here to contact us and enquire about your holiday today!</a></div></td></tr></table>
	</cfsaveContent>

	<cfset htmlText = trim(htmlText) />

	<script src="http://maps.google.com/maps?file=api&v=2&key=#application.googleKey#" type="text/javascript"></script>
	<script type="text/javascript">

		//<![CDATA[

		var geocoder;
		var map;

		var address = "Jalan Pura Telaga Waja, Petitenget, Bali";

		// On page load, call this function

		function load()
		{
		   // Create new map object
		   map = new GMap2(document.getElementById("map"));
			// add large Map Control
			map.addControl(new GLargeMapControl());
			// add map/satellite toggle
			map.addControl(new GMapTypeControl());
			// add BRHS overview control
			map.addControl(new GOverviewMapControl());

		   // Create new geocoding object
		   geocoder = new GClientGeocoder();

		   // Retrieve location information, pass it to addToMap()
		   geocoder.getLocations(address, addToMap);
		}

		// This function adds the point to the map

		function addToMap(response)
		{

		   // Retrieve the object
		   place = response.Placemark[0];

		   // Retrieve the latitude and longitude
		   <!--- point = new GLatLng(place.Point.coordinates[1],
		                       place.Point.coordinates[0]); --->
		   point = new GLatLng(-8.6799115,115.157653);

		   // Center the map on this point
		   map.setCenter(point, 13);

		   // Create a marker
		   marker = new GMarker(point);

		   // Add the marker to map
		   map.addOverlay(marker);

			//map.addControl(new google.maps.LocalSearch());
<!---

		var streetAddress = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.Thoroughfare.ThoroughfareName;
		var city = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.SubAdministrativeAreaName;
		var state = place.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName;
		var zip = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
 --->

		   // Add address information to marker
		  // marker.openInfoWindowHtml(place.address);
		   // Add address information to marker

			marker.openInfoWindowHtml('#htmlText#');

		}

		 //]]>
	</script>
</cfoutput>

<div id="map" style="width: 580px; height: 600px"></div>
