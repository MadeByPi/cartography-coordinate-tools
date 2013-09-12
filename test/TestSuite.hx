import massive.munit.TestSuite;

import GeoTest;
import LatLonTest;
import OSGridTest;
import UtilTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(GeoTest);
		add(LatLonTest);
		add(OSGridTest);
		add(UtilTest);
	}
}
