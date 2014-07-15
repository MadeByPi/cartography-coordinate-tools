package ;

import cartography.Geo;

import massive.munit.Assert;
import massive.munit.util.Timer;
import massive.munit.async.AsyncFactory;

import maths.Const;
import maths.Util;


/**
 * ...
 * @author Mike Almond - https://github.com/mikedotalmond - https://github.com/MadeByPi
 */
class GeoTest {

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
	public function degreesMinutesAndSeconds():Void {
		
		var lat  	= Geo.parseDMS("53°50′39.8498″N");
		var long 	= Geo.parseDMS("001°30′48.5492″W");
		
		var rLat 	= Util.roundToSF(lat, 8);
		var rLong 	= Util.roundToSF(long, 8);
		
		// 8 sig-fig is plenty... 4 is more likely
		
		Assert.areEqual(rLat , 53.844403);
		Assert.areEqual(Util.roundToSF(rLat, 4) , 53.84);
		
		Assert.areEqual(rLong, -1.5134859);
		Assert.areEqual(Util.roundToSF(rLong, 4), -1.513);
		
		
		Assert.areEqual(Geo.toDMS( rLat, GeoFormat.Degrees), "053.84°");
		Assert.areEqual(Geo.toDMS( rLat, GeoFormat.DegreesMinutes), "0053°50.7′");
		Assert.areEqual(Geo.toDMS( rLat, GeoFormat.DegreesMinutesSeconds), "0053°50′39.9″");
		
		Assert.areEqual(Geo.toDMS( rLong, GeoFormat.Degrees), "001.513°");
		Assert.areEqual(Geo.toDMS( rLong,  GeoFormat.DegreesMinutes), "01°30.8′");
		Assert.areEqual(Geo.toDMS( rLong, GeoFormat.DegreesMinutesSeconds), "01°30′48.5″");
		
	}
	
	@Test
	public function beargings() {
		trace(Geo.toBrng(90));
		
	}
}