<?php
require_once __DIR__ . '/bootstrap.php';

$server = new soap_server();
$server->configureWSDL("shipcharge", "urn:shipcharge");

function distance($toLat, $toLng, $fromLat, $fromLng) {
  $theta = $toLng - $fromLng;
  $dist = sin(deg2rad($toLat)) * sin(deg2rad($fromLat))
			+ cos(deg2rad($toLat)) * cos(deg2rad($fromLat)) * cos(deg2rad($theta));
  $dist = acos($dist);
  $dist = rad2deg($dist);
  $miles = $dist * 60 * 1.1515;
  return round($miles);
}

function getProd($category) {
    if ($category == "books") {
		return join(",", array(
            "The WordPress Anthology",
            "PHP Master: Write Cutting Edge Code",
            "Build Your Own Website the Right Way"));
	}
	else {
		return "No products listed under that category";
	}
}


$server->wsdl->addComplexType(
	'geoPoint',
	'complexType',
	'struct',
	'all',
	'',
	array(
		'latitude' => array(
			'name' => 'latitude',
			'type' => 'xsd:float'
		),
		'longitude' => array(
			'name' => 'longitude',
			'type' => 'xsd:float'
		)
	)
);

$server->wsdl->addComplexType(
	'geoPoints',
	'complexType',
	'array',
	'',
	'SOAP-ENC:Array',
	array(),
	array(
		array('ref'=>'SOAP-ENC:arrayType','wsdl:arrayType'=>'tns:geoPoint[]')
	),
	'tns:geoPoint'
);

define('SHIP_CHARGE_DIST_MIN', 500);
define('SHIP_CHARGE_PER_MILE', 0.05);
function calcShipCharge($to, $from) {
	$dist = distance($to['latitude'], $to['longitude'], $from['latitude'], $from['longitude']);
	return ($dist < SHIP_CHARGE_DIST_MIN ?
				SHIP_CHARGE_PER_MILE * SHIP_CHARGE_DIST_MIN :
				SHIP_CHARGE_PER_MILE * $dist);
}

$server->register("calcShipCharge",
    array(
		"to"   => "tns:geoPoint",
		"from" => "tns:geoPoint"
	),
    array("shipCharge" => "xsd:float"),
    "urn:shipcharge",
    "urn:shipcharge#calcShipCharge",
    "rpc",
    "encoded",
    "Calculate shipping charge to a given location from the list of distribution points"
);

if ( !isset( $HTTP_RAW_POST_DATA ) ) $HTTP_RAW_POST_DATA =file_get_contents( 'php://input' );
$server->service($HTTP_RAW_POST_DATA);

