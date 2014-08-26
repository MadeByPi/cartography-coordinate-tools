package cartography;

import cartography.Const;
import cartography.Util;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/*  Geodesy representation conversion functions (c) Chris Veness 2002-2012                        */
/*   - www.movable-type.co.uk/scripts/latlong.html                                                */
/*                                                                                                */
/*  Sample usage:                                                                                 */
/*    var lat = Geo.parseDMS('51° 28′ 40.12″ N');                                                 */
/*    var lon = Geo.parseDMS('000° 00′ 05.31″ W');                                                */
/*    var p1 = new LatLon(lat, lon);                                                              */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

enum GeoFormat {
	Degrees;
	DegreesMinutes;
	DegreesMinutesSeconds;
}

#if jsModule @:keep @:expose('cartography.Geo') #end
class Geo {
	
	static var DegreeSymbol		:String = "°";
	static var PrimeSymbol		:String = "′";
	static var DoublePrimeSymbol:String = "″";
	
	static var AllWhitespace:EReg = ~/\s+/g;
	
	static var TrimStart	:EReg = ~/^\s\s*/;
	static var TrimEnd		:EReg = ~/\s\s*$/;
	
	static var Sign			:EReg = ~/^-/;
	static var Compass		:EReg = ~/[NSEW]$/i;
	static var DMS			:EReg = ~/[^0-9.,]+/g;
	
	static var isNegative	:EReg = ~/^-|[WS]$/i; // take '-', west and south as negative
	
	public static function stripWhitespace(value:String):String return AllWhitespace.replace(value, '');
	public static function trimInput(value:String):String return TrimEnd.replace(TrimStart.replace(value, ''), '');
	
	//TODO: move those static regex etc somewhere else....
	
	/**
	 * Parses string representing degrees/minutes/seconds into numeric degrees
	 *
	 * This is very flexible on formats, allowing signed decimal degrees, or deg-min-sec optionally
	 * suffixed by compass direction (NSEW). A variety of separators are accepted (eg 3° 37' 09"W)
	 * or fixed-width format without separators (eg 0033709W). Seconds and minutes may be omitted.
	 * (Note minimal validation is done).
	 *
	 * @param   {String|Number} dmsIntput: Degrees or deg/min/sec in variety of formats
	 * @return 	{Number} Degrees as decimal number
	 */
	public static function parseDMS(dmsIntput:String):Float {
		
		dmsIntput = trimInput(dmsIntput); // pre trim
		
		//trace('parseDMS: ${dmsIntput}');
		
		var dms:Array<String> = DMS.split(Compass.replace(Sign.replace(dmsIntput, ''), ''));
		if (dms == null || dms.length == 0) return Math.NaN;
		
		// strip off any sign or compass dir'n & split out separate d/m/s
		if (dms[dms.length - 1] == '') dms.splice(dms.length - 1, 1);  // from trailing symbol
		
		//trace(dms);
		
		var deg = .0;
		
		// and convert to decimal degrees...
		switch (dms.length) {
			case 3:  // interpret 3-part result as d/m/s
				deg = Std.parseFloat(dms[0]) / 1 + Std.parseFloat(dms[1]) / 60 + Std.parseFloat(dms[2]) / 3600;
		
			case 2:  // interpret 2-part result as d/m
				deg = Std.parseFloat(dms[0]) / 1 + Std.parseFloat(dms[1]) / 60;
				
			case 1:  // just d (possibly decimal) or non-separated dddmmss
				deg = Std.parseFloat(dms[0]);
				// check for fixed-width unseparated format eg 0033709W
				//if (/[NS]/i.test(dmsIntput)) deg = '0' + deg;  // - normalise N/S to 3-digit degrees
				//if (/[0-9]{7}/.test(deg)) deg = deg.slice(0,3)/1 + deg.slice(3,5)/60 + deg.slice(5)/3600;
				
			default:
				return Math.NaN;
		}
		
		
		if (isNegative.match(dmsIntput)) deg = -deg;
		
		return (deg);
	}

	
	/**
	 * Convert decimal degrees to deg/min/sec format
	 *  - degree, prime, double-prime symbols are added, but sign is discarded, though no compass
	 *    direction is added
	 *
	 * @private
	 * @param   {Number} deg: Degrees
	 * @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
	 * @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
	 * @return 	{String} deg formatted as deg/min/secs according to specified format
	 */
	public static function toDMS(deg:Float, format:GeoFormat, dp:Int=-1):String {
		if (format == null) format = GeoFormat.DegreesMinutesSeconds;
		
		// default values
		if (dp == -1) {
			switch (format) {
				case GeoFormat.Degrees				 	: dp = 4;
				case GeoFormat.DegreesMinutes		 	: dp = 2;
				case GeoFormat.DegreesMinutesSeconds 	: dp = 0;
			}
		}
		
		deg = Math.abs(deg);  // (unsigned result ready for appending compass dir'n)
		
		var d		:Float = 0;
		var prefix	:String = '';
		var dms		:String = null;
		
		switch (format) {
			case GeoFormat.Degrees:
				
				d = Util.roundToSF(deg, dp);   		// round degrees
				
				if (d < 10)  		prefix = '00';	// pad with leading zeros
				else if (d < 100) 	prefix = '0';
				
				dms = '${prefix}${d}${DegreeSymbol}';	// add ° symbol
				
				
			case GeoFormat.DegreesMinutes:
				
				
				var min = Util.roundToSF(deg * 60, dp);// convert degrees to minutes & round
				var d 	= Math.floor(min / 60);   	 // get component deg/min
				var m 	= Util.roundToSF(min % 60, dp);
				
				if (d < 10)  		prefix = '0';
				else if (d < 100) 	prefix = '00';
				
				dms = '${prefix}${d}${DegreeSymbol}${(m < 10) ? "0" + m : Std.string(m)}${PrimeSymbol}';  // add °, '
				
				
			case GeoFormat.DegreesMinutesSeconds:
				
				var sec = Util.roundToSF(deg * 3600, dp);  // convert degrees to seconds & round
				
				var d 	= Math.floor(sec / 3600);   	 // get component deg/min/sec
				var m 	= Math.floor(sec / 60) % 60;
				var s 	= Util.roundToSF(sec % 60, dp);
				
				if (d < 10)  		prefix = '0';
				else if (d < 100) 	prefix = '00';
				
				dms = '${prefix}${d}${DegreeSymbol}${(m < 10) ? "0" + m : Std.string(m)}${PrimeSymbol}${(s < 10) ? "0" + s : Std.string(s)}${DoublePrimeSymbol}';
		}
		
		return dms;
	}


	/**
	 * Convert numeric degrees to deg/min/sec latitude (suffixed with N/S)
	 *
	 * @param   {Number} deg: Degrees
	 * @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
	 * @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
	 * @return 	{String} Deg/min/seconds
	 */
	public static function toLat(deg:Float, format:GeoFormat=null, dp:Int=-1):String {
		var lat = Geo.toDMS(deg, format, dp);
		return lat == null ? null : lat.substr(1) + (deg < 0 ? 'S' : 'N');  // knock off initial '0' for lat!
	}


	/**
	 * Convert numeric degrees to deg/min/sec longitude (suffixed with E/W)
	 *
	 * @param   {Number} deg: Degrees
	 * @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
	 * @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
	 * @return 	{String} Deg/min/seconds
	 */
	public static function toLon(deg:Float, format:GeoFormat=null, dp:Int=-1):String {
	  var lon = Geo.toDMS(deg, format, dp);
	  return lon == null ? null : lon + (deg < 0 ? 'W' : 'E');
	}


	/**
	 * Convert numeric degrees to deg/min/sec as a bearing (0°..360°)
	 *
	 * @param   {Number} deg: Degrees
	 * @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
	 * @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
	 * @return 	{String} Deg/min/seconds
	 */
	public static function toBrng(deg:Float, format:GeoFormat=null, dp:Int=-1):String {
		deg = (deg+360) % 360;  // normalise -ve values to 180°..360°
		var brng = Geo.toDMS(deg, format, dp);
		return brng == null ? null : ~/360/i.replace(brng, '0');  // just in case rounding took us up to 360°!
	}
}