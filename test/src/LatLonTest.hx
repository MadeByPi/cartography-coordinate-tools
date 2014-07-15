package ;

import cartography.Geo;
import cartography.LatLon;

import maths.Const;
import maths.Util;

import massive.munit.Assert;
import massive.munit.util.Timer;
import massive.munit.async.AsyncFactory;

/**
 * ...
 * @author Mike Almond - https://github.com/mikedotalmond - https://github.com/MadeByPi
 */
class LatLonTest {

	public function new() { }
	
	
	@Test
	public function degreesMinutesAndSeconds():Void {
		
		var pointA:LatLon = new LatLon(Geo.parseDMS("53°50′39.8498″N"), Geo.parseDMS("001°30′48.5492″W")); // Leeds
		var pointB:LatLon = new LatLon(50.823404, -0.138375); // Brighton
		
		trace('pointA: ${pointA}');
		trace('pointB: ${pointB}');
		
		trace('A->B distance = ${pointA.distanceTo(pointB)}');
		trace('B->A distance = ${pointB.distanceTo(pointA)}');
		
		trace('A->B midpoint  = ${pointA.midpointTo(pointB)}');
		trace('B->A midpoint  = ${pointB.midpointTo(pointA)}');
		
		//trace('A->B bearing  = ${pointA.bearingTo(pointB)}');
		//trace('B->A bearing  = ${pointB.bearingTo(pointA)}');
		
		//pointA.midpointTo(pointB);
		//pointB.midpointTo(pointA);
		
		Assert.areNotEqual(pointA, pointB);
		
		Assert.areEqual(pointA.distanceTo(pointB), pointB.distanceTo(pointA));
		
		Assert.areEqual(Util.roundToSF(pointA.distanceTo(pointA.midpointTo(pointB)), 4), Util.roundToSF(pointA.distanceTo(pointB) / 2, 4));
		
		Assert.areEqual(pointA.midpointTo(pointB).lat, pointB.midpointTo(pointA).lat);
		Assert.areEqual(pointA.midpointTo(pointB).lon, pointB.midpointTo(pointA).lon);
		
		//trace(Util.roundToSF(pointA.bearingTo(pointB),4));
		//trace(Util.roundToSF(pointB.bearingTo(pointA),4));
		//pointB.bearingTo(pointA); // some error here... ~1.1 degree difference between a>b and b>a
		
		//LatLon.intersection();
		
		// 8 sig-fig is plenty... 4 is more likely
		
		
	}
	
}