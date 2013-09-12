package;

import cartography.CoordTransform;
import cartography.Geo;
import cartography.LatLon;
import cartography.OSGridRef;
import maths.Util;

import massive.munit.Assert;

/**
 * ...
 * @author Mike Almond - https://github.com/mikedotalmond - https://github.com/MadeByPi
 */

class OSGridTest {
	
	public function new() {
		
	}
	
	@BeforeClass
	public function beforeClass():Void {
	}
	
	@AfterClass
	public function afterClass():Void {
		
	}
	
	
	@Before
	public function setup():Void {
		
	}
	
	@After
	public function tearDown():Void {
		
	}
	
	
	
	@Test
	public function OSGToLatLong():Void {
		
		var LS8_1AW_OSG 	= new OSGridRef(432108, 438794);
		
		var lat = Geo.parseDMS("53°50′39.8498″N"); // lat
		var lon = Geo.parseDMS("001°30′48.5492″W"); //lon
		
		var LS8_1AW_LatLon	= new LatLon(lat, lon); // WGS format
		trace(LS8_1AW_LatLon);
		
		//var LS8_1AW_LatLon	= new LatLon(53.844403, -1.513486); // WGS format
		
		var osg_converted:LatLon = OSGridRef.osGridToLatLong(LS8_1AW_OSG);
		var wgs_converted:LatLon = CoordTransform.convertOSGB36toWGS84(osg_converted);
		
		trace(LS8_1AW_LatLon.lat);
		trace(LS8_1AW_LatLon.lon);
		
		trace(wgs_converted.lat);
		trace(wgs_converted.lon);
		
		// precision is limited, max is about 6sigfig +- .0001
		Assert.areEqual(Util.roundToSF(LS8_1AW_LatLon.lat, 5), Util.roundToSF(wgs_converted.lat, 5));
		Assert.areEqual(Util.roundToSF(LS8_1AW_LatLon.lon, 5), Util.roundToSF(wgs_converted.lon, 5));
	}
	
	@Test
	public function latLongToOSG() {
		
		var lat = Geo.parseDMS("53°50′39.8498″N"); // lat
		var lon = Geo.parseDMS("001°30′48.5492″W"); //lon
		
		var LS8_1AW_LatLon	= new LatLon(lat,lon); //WGS format
		
		var osgLatLon = CoordTransform.convertWGS84toOSGB36(LS8_1AW_LatLon);
		
		var converted:OSGridRef = OSGridRef.latLongToOsGrid(osgLatLon);
		
		trace(LS8_1AW_LatLon);
		trace(osgLatLon);
		trace(converted);
		
		//
		Assert.areEqual(432108, converted.easting);
		Assert.areEqual(438794, converted.northing);
	}
}