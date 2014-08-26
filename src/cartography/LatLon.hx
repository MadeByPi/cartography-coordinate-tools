package cartography;

import cartography.Geo;

import cartography.Const;
import cartography.Util;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/*  Latitude/longitude spherical geodesy formulae & scripts (c) Chris Veness 2002-2012            */
/*   - www.movable-type.co.uk/scripts/latlong.html                                                */
/*                                                                                                */
/*  Sample usage:                                                                                 */
/*    var p1 = new LatLon(51.5136, -0.0983);                                                      */
/*    var p2 = new LatLon(51.4778, -0.0015);                                                      */
/*    var dist = p1.distanceTo(p2);          // in km                                             */
/*    var brng = p1.bearingTo(p2);           // in degrees clockwise from north                   */
/*    ... etc                                                                                     */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/*  Note that minimal error checking is performed in this example code!                           */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */



/**
 * Creates a point on the earth's surface at the supplied latitude / longitude
 *
 * @param {Float} lat: latitude in numeric degrees
 * @param {Float} lon: longitude in numeric degrees
 * @param {Float} [rad=6371]: radius of earth if different value is required from standard 6,371km
 */

#if jsModule @:keep @:expose('cartography.LatLon') #end
class LatLon {
	
	var radius:Float; // (earth) km
	
	public var lat		(default, null):Float; // degrees
	public var lon		(default, null):Float;
	
	public var r_lat	(default, null):Float; // radians
	public var r_lon	(default, null):Float;
	
	
	/**
	 *
	 * @param	lat Degrees
	 * @param	lon Degrees
	 * @param	?radius km - defaults to MeanEarthRadius_km ~6371 km
	 */
	public function new(lat:Float, lon:Float, ?radius:Float = Const.MeanEarthRadius_km) {
		
		this.lat 	= lat;
		this.lon 	= lon;
		this.radius = radius;
		
		r_lat 		= Util.toRadians(lat);
		r_lon 		= Util.toRadians(lon);
	}
	
	
	/**
	 * Returns the distance from this point to the supplied point, in km
	 * (using Haversine formula)
	 *
	 * from: Haversine formula - R. W. Sinnott, "Virtues of the Haversine",
	 *       Sky and Telescope, vol 68, no 2, 1984
	 *
	 * @param   {LatLon} point: Latitude/longitude of destination point
	 * @param   {Int} [precision=4]: no of significant digits to use for returned value
	 * @return {Float} Distance in km between this point and destination point
	 */
	public function distanceTo(point:LatLon, precision:Int=4):Float {
		
		// default 4 sig figs reflects typical 0.3% accuracy of spherical model
		
		var lat1 = r_lat, lon1 = r_lon;
		var lat2 = point.r_lat, lon2 = point.r_lon;
		
		var dLat = Math.sin((lat2 - lat1) / 2);
		var dLon = Math.sin((lon2 - lon1) / 2);
		
		var a = dLat 			* dLat +
				Math.cos(lat1)	* Math.cos(lat2) *
				dLon		 	* dLon;
		
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		var d = radius * c;
		
		return Util.roundToSF(d, precision);
	}
	
	
	/**
	 * Returns the (initial) bearing from this point to the supplied point, in degrees
	 *  see http://williams.best.vwh.net/avform.htm#Crs
	 *
	 * @param  {LatLon} point: Latitude/longitude of destination point
	 * @return {Float} Initial bearing in degrees from North
	 */
	public function bearingTo(point:LatLon):Float {
		
		var lat1 	= r_lat, lat2 = point.r_lat;
		var dLon 	= point.r_lon - r_lon;
		
		var y 		= Math.sin(dLon) * Math.cos(lat2);
		var x 		= Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
		
		var brng 	= Math.atan2(y, x);
		
		return (Util.toDegrees(brng) + 360) % 360;
	}


	/**
	 * Returns final bearing arriving at supplied destination point from this point; the final bearing
	 * will differ from the initial bearing by varying degrees according to distance and latitude
	 *
	 * @param   {LatLon} point: Latitude/longitude of destination point
	 * @return {Float} Final bearing in degrees from North
	 */
	public function finalBearingTo(point:LatLon):Float {
		//var toRad = Util.toRadians;
		
		// get initial bearing from supplied point back to this point...
		var lat1 = point.r_lat, lat2 = r_lat;
		var dLon = r_lon - point.r_lon;
		
		var y 		= Math.sin(dLon) * Math.cos(lat2);
		var x 		= Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
		var brng 	= Math.atan2(y, x);
		
		// ... & reverse it by adding 180°
		return (Util.toDegrees(brng) + 180) % 360;
	}
	
	
	/**
	 * Returns the midpoint between this point and the supplied point.
	 *   see http://mathforum.org/library/drmath/view/51822.html for derivation
	 *
	 * @param   {LatLon} point: Latitude/longitude of destination point
	 * @return {LatLon} Midpoint between this point and the supplied point
	 */
	public function midpointTo(point:LatLon):LatLon {
		
		//var toRad = Util.toRadians;
		var toDeg = Util.toDegrees;
		
		var lat1 = r_lat, lon1 = r_lon;
		var lat2 = point.r_lat;
		var dLon = point.r_lon - r_lon;
		
		var clat2 	= Math.cos(lat2);
		var Bx 		= clat2 * Math.cos(dLon);
		var By 		= clat2 * Math.sin(dLon);
		
		var lat3 = Math.atan2(
			Math.sin(lat1) + Math.sin(lat2),
			Math.sqrt((Math.cos(lat1) + Bx) * (Math.cos(lat1) + Bx) + By * By)
		);
		
		var lon3 = lon1 + Math.atan2(By, Math.cos(lat1) + Bx);
			lon3 = (lon3 + Const.ThreePi) % Const.TwoPi - Const.Pi;  // normalise to -180..+180º
		
		return new LatLon(toDeg(lat3), toDeg(lon3));
	}


	/**
	 * Returns the destination point from this point having travelled the given distance (in km) on the
	 * given initial bearing (bearing may vary before destination is reached)
	 *
	 *   see http://williams.best.vwh.net/avform.htm#LL
	 *
	 * @param   {Float} brng: Initial bearing in degrees
	 * @param   {Float} dist: Distance in km
	 * @return {LatLon} Destination point
	 */
	public function destinationPoint(brng:Float, dist:Float):LatLon {
	
		var toRad = Util.toRadians;
	
		dist = dist/radius;  // convert dist to angular distance in radians
		brng = toRad(brng);  //
	
		var lat1  = r_lat, lon1 = r_lon;
		var sdist = Math.sin(dist);
		var cdist = Math.cos(dist);
		var slat1 = Math.sin(lat1);
		var clat1 = Math.cos(lat1);

		var lat2 = Math.asin(slat1 * cdist + clat1 * sdist * Math.cos(brng));
		var lon2 = lon1 + Math.atan2(Math.sin(brng) * sdist * clat1, cdist - slat1 * Math.sin(lat2));
		
		lon2 	= (lon2 + Const.ThreePi) % (Const.TwoPi) - Const.Pi;  // normalise to -180..+180º

		return new LatLon(Util.toDegrees(lat2), Util.toDegrees(lon2));
	}
	


	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

	/**
	 * Returns the distance from this point to the supplied point, in km, travelling along a rhumb line
	 *
	 *   see http://williams.best.vwh.net/avform.htm#Rhumb
	 *
	 * @param   {LatLon} point: Latitude/longitude of destination point
	 * @return {Float} Distance in km between this point and destination point
	 */
	public function rhumbDistanceTo(point:LatLon):Float {
		var toRad = Util.toRadians;
				
		var lat1 = (r_lat), lat2 = (point.r_lat);
		var dLat = (point.r_lat - r_lat);
		var dLon = (Math.abs(point.r_lon - r_lon));

		var dPhi = Math.log(Math.tan(lat2 / 2 + Const.Pi / 4) / Math.tan(lat1 / 2 + Const.Pi / 4));
		var q = (Math.isFinite(dLat/dPhi)) ? dLat/dPhi : Math.cos(lat1);  // E-W line gives dPhi=0
		
		// if dLon over 180° take shorter rhumb across anti-meridian:
		if (Math.abs(dLon) > Const.Pi) {
			dLon = dLon > 0 ? -(Const.TwoPi - dLon) : (Const.TwoPi + dLon);
		}

		var dist = Math.sqrt(dLat * dLat + q * q * dLon * dLon) * radius;
		
		return Util.roundToSF(dist, 4); // 4 sig figs reflects typical 0.3% accuracy of spherical model
	}

	/**
	 * Returns the bearing from this point to the supplied point along a rhumb line, in degrees
	 *
	 * @param   {LatLon} point: Latitude/longitude of destination point
	 * @return {Float} Bearing in degrees from North
	 */
	public function rhumbBearingTo(point) {
		var toRad = Util.toRadians;
		
		var lat1 = (r_lat), lat2 = (point.r_lat);
		var dLon = (point.r_lon-r_lon);
		
		var dPhi = Math.log(Math.tan(lat2 / 2 + Const.Pi / 4) / Math.tan(lat1 / 2 + Const.Pi / 4));
		if (Math.abs(dLon) > Const.Pi) dLon = dLon > 0 ? -(Const.TwoPi - dLon) : (Const.TwoPi + dLon);
		var brng = Math.atan2(dLon, dPhi);
		
		return (Util.toDegrees(brng) + 360) % 360;
	}

	/**
	 * Returns the destination point from this point having travelled the given distance (in km) on the
	 * given bearing along a rhumb line
	 *
	 * @param   {Float} brng: Bearing in degrees from North
	 * @param   {Float} dist: Distance in km
	 * @return {LatLon} Destination point
	 */
	public function rhumbDestinationPoint(brng:Float, dist:Float):LatLon {
		
		var toRad = Util.toRadians;
		
		var R = radius;
		var d = dist / R;  // d = angular distance covered on earth’s surface
		var lat1 = (r_lat), lon1 = (r_lon);
		brng = toRad(brng);
		
		var dLat = d * Math.cos(brng);
		// nasty kludge to overcome ill-conditioned results around parallels of latitude:
		if (Math.abs(dLat) < Const.EPSILON) dLat = 0; // dLat < 1 mm
		
		var lat2 = lat1 + dLat;
		var dPhi = Math.log(Math.tan(lat2 / 2 + Const.Pi / 4) / Math.tan(lat1 / 2 + Const.Pi / 4));
		var q = (Math.isFinite(dLat / dPhi)) ? dLat / dPhi : Math.cos(lat1);  // E-W line gives dPhi=0
		var dLon = d * Math.sin(brng) / q;
		
		// check for some daft bugger going past the pole, normalise latitude if so
		if (Math.abs(lat2) > Const.Pi/2) lat2 = lat2>0 ? Const.Pi-lat2 : -Const.Pi-lat2;
		
		var lon2 = (lon1 + dLon + Const.ThreePi) % (Const.TwoPi) - Const.Pi;
		
		return new LatLon(Util.toDegrees(lat2), Util.toDegrees(lon2));
	}

	/**
	 * Returns the loxodromic midpoint (along a rhumb line) between this point and the supplied point.
	 *   see http://mathforum.org/kb/message.jspa?messageID=148837
	 *
	 * @param   {LatLon} point: Latitude/longitude of destination point
	 * @return {LatLon} Midpoint between this point and the supplied point
	 */
	public function rhumbMidpointTo(point:LatLon):LatLon {
		var toRad = Util.toRadians;
		
		var lat1 = (r_lat), lon1 = (r_lon);
		var lat2 = (point.r_lat), lon2 = (point.r_lon);
		
		if (Math.abs(lon2-lon1) > Const.Pi) lon1 += Const.TwoPi; // crossing anti-meridian
		
		var lat3 = (lat1 + lat2) / 2;
		var f1 = Math.tan(Const.Pi / 4 + lat1 / 2);
		var f2 = Math.tan(Const.Pi / 4 + lat2 / 2);
		var f3 = Math.tan(Const.Pi / 4 + lat3 / 2);
		var lon3 = ( (lon2 - lon1) * Math.log(f3) + lon1 * Math.log(f2) - lon2 * Math.log(f1) ) / Math.log(f2 / f1);
		
		if (!Math.isFinite(lon3)) lon3 = (lon1+lon2)/2; // parallel of latitude
		
		lon3 = (lon3 + Const.ThreePi) % (Const.TwoPi) - Const.Pi;  // normalise to -180..+180º
		
		return new LatLon(Util.toDegrees(lat3), Util.toDegrees(lon3));
	}


	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

	/**
	 * Returns a string representation of this point; format and dp as per lat()/lon()
	 *
	 * @param   {String} [format]: Return value as 'd', 'dm', 'dms'
	 * @param   {Int} [dp=0|2|4]: No of decimal places to display
	 * @return {String} Comma-separated latitude/longitude
	 */
	public function toString(format:GeoFormat=null, dp:Int = -1):String {
		return '${Geo.toLat(lat, format, dp)},${Geo.toLon(lon, format, dp)}';
	}
	
	
	
	
	
	/**
	 * Returns the point of intersection of two paths defined by point and bearing
	 *   see http://williams.best.vwh.net/avform.htm#Intersection
	 *
	 * @param   {LatLon} p1: First point
	 * @param   {Float} brng1: Initial bearing from first point
	 * @param   {LatLon} p2: Second point
	 * @param   {Float} brng2: Initial bearing from second point
	 * @return {LatLon} Destination point (null if no unique intersection defined)
	 */
	public static function intersection(p1:LatLon, brng1:Float, p2:LatLon, brng2:Float):LatLon {
		
		var toRad = Util.toRadians;
		
		var lat1 = (p1.r_lat), lon1 = (p1.r_lon);
		var lat2 = (p2.r_lat), lon2 = (p2.r_lon);
		
		var brng13 	= toRad(brng1), brng23 = toRad(brng2);
		var dLat	= lat2-lat1, dLon = lon2-lon1;
		
		var sDlat2 = Math.sin(dLat / 2);
		var sDlon2 = Math.sin(dLon / 2);
		
		var dist12 = 2 * Math.asin( Math.sqrt( sDlat2 * sDlat2 + Math.cos(lat1) * Math.cos(lat2) * sDlon2 * sDlon2));
		if (dist12 == 0) return null;
		
		var sLat1 	= Math.sin(lat1);
		var cLat1 	= Math.cos(lat1);
		var sDist12 = Math.sin(dist12);
		var cDist12 = Math.cos(dist12);
		
		// initial/final bearings between points
		var brngA = Math.acos( ( Math.sin(lat2) - sLat1 * cDist12 ) / ( sDist12 * cLat1 ) );
		if (Math.isNaN(brngA)) brngA = 0;  // protect against rounding
		
		var brngB = Math.acos( ( sLat1 - Math.sin(lat2) * cDist12 ) / ( sDist12 * Math.cos(lat2) ) );

		var brng12,brng21;
		if (Math.sin(lon2-lon1) > 0) {
			brng12 = brngA;
			brng21 = Const.TwoPi - brngB;
		} else {
			brng12 = Const.TwoPi - brngA;
			brng21 = brngB;
		}
		
		var alpha1 = (brng13 - brng12 + Const.Pi) % (Const.TwoPi) - Const.Pi;  // angle 2-1-3
		var alpha2 = (brng21 - brng23 + Const.Pi) % (Const.TwoPi) - Const.Pi;  // angle 1-2-3
		
		var salpha1 = Math.sin(alpha1);
		var salpha2 = Math.sin(alpha2);
		
		if (salpha1 == 0 && salpha2 == 0) return null; // infinite intersections
		
		var salpha12 = salpha1 * salpha2;
		if (salpha12 < 0) return null; // ambiguous intersection
		
		var alpha3 	= Math.acos( -Math.cos(alpha1) * Math.cos(alpha2) + salpha12 * Math.cos(dist12) );
		var dist13 	= Math.atan2( Math.sin(dist12) * salpha12, Math.cos(alpha2) + Math.cos(alpha1) * Math.cos(alpha3) );
		
		var lat3 	= Math.asin( Math.sin(lat1) * Math.cos(dist13) + Math.cos(lat1) * Math.sin(dist13) * Math.cos(brng13) );
		var dLon13 	= Math.atan2( Math.sin(brng13) * Math.sin(dist13) * Math.cos(lat1), Math.cos(dist13) - Math.sin(lat1) * Math.sin(lat3) );
		
		var lon3 = (lon1 + dLon13 + Const.ThreePi) % (Const.TwoPi) - Const.Pi;  // normalise to -180..+180º
		
		return new LatLon(Util.toDegrees(lat3), Util.toDegrees(lon3));
	}
}
