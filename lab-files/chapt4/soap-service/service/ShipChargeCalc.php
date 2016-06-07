<?php
require_once __DIR__ . '/bootstrap.php';

$server = new soap_server();
$server->configureWSDL("shipcharge", "urn:shipcharge");

function zipGeo ($zip = null) {
	static $zipData = null;

	// Data wasn't previously loaded from CSV
    if (is_null($zipData) or is_null($zip)) {
		$fh = fopen("../zipdata/zipcode.csv", "r");

		// Skip the headerline
		fgetcsv($fh, 1024);

		$zipData = [];
		while (!feof($fh)) {
			$columns = fgetcsv($fh, 1024);
			$zipData[$columns[0]] = array(
										"city" => $columns[1],
										"state" => $columns[2],
										"latitude" => $columns[3],
										"longitude" => $columns[4],
										"timezone" => $columns[5],
										"dst" => ($columns[6] == 1 ? true : false)
									);
		}
		fclose($fh);
		return null;
	}

	// Lookup the Geo coordinates for the specified Zip
	$geo = null;
	if (array_key_exists($zip, $zipData)) {
		$geo = array (
						'latitude' => $zipData[$zip]['latitude'],
						'longitude' => $zipData[$zip]['longitude']
					);
	}

	return $geo;
}


function distance ($toLat, $toLng, $fromLat, $fromLng) {
  $theta = $toLng - $fromLng;
  $dist = sin(deg2rad($toLat)) * sin(deg2rad($fromLat))
			+ cos(deg2rad($toLat)) * cos(deg2rad($fromLat)) * cos(deg2rad($theta));
  $dist = acos($dist);
  $dist = rad2deg($dist);
  $miles = $dist * 60 * 1.1515;
  return round($miles);
}

define('SHIP_CHARGE_DIST_MIN', 250);
define('SHIP_CHARGE_PER_MILE', 0.05);
function calcShipCharge($to, $from) {
	$toGeo = zipGeo($to);
	if (is_null($toGeo))
		return new soap_fault('Server','', "To '" . $to . "' isn't a valid Zip code",'');

	$fromArr = split(',', $from);
	$fromGeo = [];
	foreach ($fromArr as $zip) {
		$fromGeo[$zip] = zipGeo($zip);
		if (is_null($fromGeo[$zip]))
			return new soap_fault('Server','', "From: '" . $zip . "' isn't a valid Zip code",'');
	}

	$dist = [];

	foreach ($fromGeo as $f) {
		array_push($dist, distance($toGeo['latitude'], $toGeo['longitude'], $f['latitude'], $f['longitude']));
	}
	$shortestDist = min($dist);
	return ($shortestDist < SHIP_CHARGE_DIST_MIN ?
				SHIP_CHARGE_PER_MILE * SHIP_CHARGE_DIST_MIN :
				SHIP_CHARGE_PER_MILE * $shortestDist);
}

$server->register("calcShipCharge",
    array(
		"to"   => "xsd:string",
		"from" => "xsd:string"
	),
    array("shipCharge" => "xsd:float"),
    "urn:shipcharge",
    "urn:shipcharge#calcShipCharge",
    "rpc",
    "encoded",
    "Calculate shipping charge to a given location from the list of distribution points"
);


// Load the Zip codes data
zipGeo();

if ( !isset( $HTTP_RAW_POST_DATA ) ) $HTTP_RAW_POST_DATA =file_get_contents( 'php://input' );
$server->service($HTTP_RAW_POST_DATA);

