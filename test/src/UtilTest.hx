package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import cartography.Const;
import cartography.Util;


/**
 * ...
 * @author Mike Almond - https://github.com/mikedotalmond - https://github.com/MadeByPi
 */
class UtilTest {

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
	public function degreesAndRadians():Void {
		
		var r = Util.roundToSF;
		
		// Test rad->deg and deg->rad is correct to within 9 significant figures... which is plenty!
		
		Assert.areEqual(r(Util.toDegrees(Const.HalfPi),9), 90);
		Assert.areEqual(r(Util.toDegrees(Const.Pi),9), 180);
		Assert.areEqual(r(Util.toDegrees(Const.TwoPi),9), 360);
		Assert.areEqual(r(Util.toDegrees(Const.ThreePi),9), 540);
		Assert.areEqual(r(Util.toDegrees(Const.FourPi),9), 720);
		
		Assert.areEqual(r(Util.toRadians(90), 9),  r(Const.HalfPi, 9));
		Assert.areEqual(r(Util.toRadians(180), 9), r(Const.Pi, 9));
		Assert.areEqual(r(Util.toRadians(360), 9), r(Const.TwoPi, 9));
		Assert.areEqual(r(Util.toRadians(540), 9), r(Const.ThreePi, 9));
		Assert.areEqual(r(Util.toRadians(720), 9), r(Const.FourPi, 9));
		
		for (i in 0...1000) {
			var t  = Math.random() * i;
			var st = r(t, 9);
			Assert.areEqual(r(Util.toRadians(Util.toDegrees(t)), 9), st);
			Assert.areEqual(r(Util.toDegrees(Util.toRadians(t)), 9), st);
		}
	}
	
	
	
	@Test
	public function roundToSignificantFigures():Void {
		
		// Const.Pi == 3.141592653589793
		var r = Util.roundToSF;
		
		Assert.areEqual(r(Const.Pi, 9), 3.14159265);
		Assert.areEqual(r(Const.Pi, 8), 3.1415927);
		Assert.areEqual(r(Const.Pi, 7), 3.141593);
		Assert.areEqual(r(Const.Pi, 6), 3.14159);
		Assert.areEqual(r(Const.Pi, 5), 3.1416);
		Assert.areEqual(r(Const.Pi, 4), 3.142);
		Assert.areEqual(r(Const.Pi, 3), 3.14);
		Assert.areEqual(r(Const.Pi, 2), 3.1);
		Assert.areEqual(r(Const.Pi, 1), 3.1);
		
		Assert.areEqual(r(Const.Pi*10, 9), 31.4159265);
		Assert.areEqual(r(Const.Pi*10, 8), 31.415927);
		Assert.areEqual(r(Const.Pi*10, 7), 31.41593);
		Assert.areEqual(r(Const.Pi*10, 6), 31.4159);
		Assert.areEqual(r(Const.Pi*10, 5), 31.416);
		Assert.areEqual(r(Const.Pi*10, 4), 31.42);
		Assert.areEqual(r(Const.Pi*10, 3), 31.4);
		Assert.areEqual(r(Const.Pi*10, 2), 31.4);
		Assert.areEqual(r(Const.Pi*10, 1), 31.4);
		
	}
}