<?php
/**
 * @license MIT
 *
 * Please see the LICENSE file distributed with this source code for further
 * information regarding copyright and licensing.
 *
 */

class ShipChargeCalcTest extends \PHPUnit_Framework_TestCase
{
    protected $client;
	const GEO = array (
					'New York' => array('latitude' => 40.7127837, 'longitude' => -74.0059413),
					'Boston' => array('latitude' => 42.3600825, 'longitude' => -71.0588801),
					'Chicago' => array('latitude' => 41.8781136, 'longitude' => -87.6297981),
					'Miami' => array('latitude' => 25.7616798, 'longitude' => -80.1917902),
					'Las Vegas' => array('latitude' => 36.1699412, 'longitude' => -115.1398296),
					'Trenton' => array('latitude' => 40.2170534, 'longitude' => -74.7429384),
					'Austin' => array('latitude' => 30.267153, 'longitude' => -97.7430608)
				);

    protected function setUp()
    {
        $this->client = new nusoap_client("http://localhost:8000/ShipChargeCalc.php/shipcharge?wsdl", true);
		$error = $this->client->getError();
		if ($error) {
			echo "Constructor error" . $error;
		}
    }

	public function testMinCharge()
	{
		$charge = $this->client->call(
									"calcShipCharge",
									array(
										"to" => self::GEO['New York'],
										"from" => self::GEO['Trenton']
									)
								);
		echo "Shipping: " . $charge;
		$this->assertEquals(52, $charge);
	}

/*
	public function testBostonToMiami()
	{
		$charge = $this->client->call(
									"calcShipCharge",
									array(
										"to" => self::GEO['Boston'],
										"from" => self::GEO['Miami']
									)
								);
		echo "Shipping: " . $charge;
		$this->assertEquals(52, $charge);
	}

	public function testAustinToChicago()
	{
		$charge = $this->client->call(
									"calcShipCharge",
									array(
										"to" => self::GEO['Austin'],
										"from" => self::GEO['Chicago']
									)
								);
		echo "Shipping: " . $charge;
		$this->assertEquals(52, $charge);
	}


	public function testSameLocation()
	{
		$charge = $this->client->call(
									"calcShipCharge",
									array(
										"to" => self::GEO['Las Vegas'],
										"from" => self::GEO['Las Vegas']
									)
								);
		echo "Shipping: " . $charge;
		$this->assertEquals(52, $charge);
	}

	public function testThereAndBack()
	{
		$charge1 = $this->client->call(
									"calcShipCharge",
									array(
										"to" => self::GEO['Boston'],
										"from" => self::GEO['Austin']
									)
								);
		$charge2 = $this->client->call(
									"calcShipCharge",
									array(
										"to" => self::GEO['Austin'],
										"from" => self::GEO['Boston']
									)
								);
		echo "Shipping: " . $charge1 . " " . $charge2;
		$this->assertEquals(52, $charge);
	}
*/
}
