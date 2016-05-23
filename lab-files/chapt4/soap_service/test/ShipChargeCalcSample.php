<?php
/**
 * @license MIT
 *
 * Please see the LICENSE file distributed with this source code for further
 * information regarding copyright and licensing.
 *
 */

require_once __DIR__ . '/bootstrap.php';

const GEO = array (
					'New York' => array('latitude' => 40.7127837, 'longitude' => -74.0059413),
					'Boston' => array('latitude' => 42.3600825, 'longitude' => -71.0588801),
					'Chicago' => array('latitude' => 41.8781136, 'longitude' => -87.6297981),
					'Miami' => array('latitude' => 25.7616798, 'longitude' => -80.1917902),
					'Las Vegas' => array('latitude' => 36.1699412, 'longitude' => -115.1398296),
					'Trenton' => array('latitude' => 40.2170534, 'longitude' => -74.7429384),
					'Austin' => array('latitude' => 30.267153, 'longitude' => -97.7430608)
				);

$client = new nusoap_client("http://localhost:8000/ShipChargeCalc.php/shipcharge?wsdl", true);
$error = $client->getError();
if ($error) {
	echo "Constructor error" . $error;
}

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['New York'],
							"from" => GEO['Trenton']
						)
					);
echo "New York --> Trenton: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Boston'],
							"from" => GEO['New York']
						)
					);
echo "Boston --> New York: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Boston'],
							"from" => GEO['Miami']
						)
					);
echo "Boston --> Miami: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Austin'],
							"from" => GEO['Chicago']
						)
					);
echo "Austin --> Chicago: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Las Vegas'],
							"from" => GEO['Las Vegas']
						)
					);
echo "Las Vegas --> Las Vegas: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Boston'],
							"from" => GEO['Austin']
						)
					);
echo "Boston --> Austin: $charge\n";

$charge = $client->call(
						"calcShipCharge",
						array(
							"to" => GEO['Austin'],
							"from" => GEO['Boston']
						)
					);
echo "Austin --> Boston: $charge\n";

