package maths;

/**
 * ...
 * @author Mike Almond - https://github.com/mikedotalmond - https://github.com/MadeByPi
 */

class Util {
	
	public static inline function toRadians(deg:Float):Float { return deg * Const.DegToRad; }
	public static inline function toDegrees(rad:Float):Float { return rad * Const.RadToDeg; }
	
	// round to (4) significant figures, eliminates < 1e-10
	public static function roundToSF(value:Float, ?sigfig:Int = 4):Float {
		
		var neg;
		if(value < 0) {
			neg 	= -1.0;
			value 	= -value;
		} else {
			neg = 1.0;
		}
		
		var digits = Std.int(sigfig - Math.log(value) / Const.Ln10);
		
		if (digits < 1) digits = 1;
		else if (digits >= 10) return 0.;
		
		var exp = Math.pow(10, digits);
		
		return Std.int(value * exp + .49999) * neg / exp;
	}
}