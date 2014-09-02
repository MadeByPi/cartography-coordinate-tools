cartography-coordinate-tools
============================

A cross-platform library providing calculators and conversion tools for earthly coordinate systems.


## With these classes you can:
* Calculate distance, bearing, and more - between Latitude/Longitude points
* Convert between Latitude/Longitude & OS National Grid Reference points
* Convert co-ordinates between WGS-84 and OSGB36


## Tests
Uses [munit](https://github.com/massiveinteractive/MassiveUnit/), with tests and coverage for JS, Flash, Neko, and C++ targets

`haxelib run munit test -coverage`


## Examples
* [This gist](https://gist.github.com/MadeByPi/e4ca09d123ef25888427) shows the conversion of UK postcode points from OS grid references (Easting/Northing) to Lan/Lon pairs.
* bin/index.html shows simple setup + use of the library as a JS module.


## Ported from JS libraries by Chris Veness:
* http://movable-type.co.uk/scripts/latlong.html
* http://movable-type.co.uk/scripts/latlong-gridref.html
* http://movable-type.co.uk/scripts/latlong-convert-coords.html


## Licence
* [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/)
