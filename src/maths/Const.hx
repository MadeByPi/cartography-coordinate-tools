package maths;

@:final class Const {
	
	#if neko
	public static inline var  EPSILON	:Float =  1e-6;
	#else
	public static inline var  EPSILON	:Float =  1e-10;
	#end
	
	public static inline var Sqrt2		:Float = 1.4142135623730951;
	public static inline var Sqrt1_2	:Float = 0.7071067811865475;
	
	public static inline var Log2e		:Float = 1.4426950408889634;
	public static inline var Log10e		:Float = 0.4342944819032518;
	
	public static inline var e			:Float =  2.718281828459045;
	public static inline var Ln2		:Float =  0.6931471805599453;
	public static inline var Ln10		:Float =  2.302585092994046;
	
	public static inline var DegToRad	:Float = 0.017453292519943295; // Pi / 180;
	public static inline var RadToDeg	:Float = 57.29577951308232; // 180 / Pi;
	
	public static inline var MinValue	:Float = 4.94065645841247e-324; //
	public static inline var MaxValue	:Float = 1.79769313486231e+308;
	
	public static inline var Pi			:Float = 3.141592653589793;
	public static inline var FourPi		:Float = 12.566370614359172;
	public static inline var TwoPi		:Float = 6.283185307179586;
	public static inline var ThreePi	:Float = 9.42477796076938;
	public static inline var HalfPi		:Float = 1.5707963267948966;
	public static inline var ThirdPi	:Float = 1.0471975511965976;
	public static inline var TwoThirdsPi:Float = 2.0943951023931953;
	
	public static inline var OneSixth	:Float = 0.16666666666666666;
	
	public static inline var MeanEarthRadius_km:Float = 6371.009;
	// Mean earth radius - https://en.wikipedia.org/wiki/Earth_radius#Mean_radii
	
}