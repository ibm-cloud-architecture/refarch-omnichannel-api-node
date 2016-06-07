var server = require('../../server/server');
var loopback = require('loopback');

module.exports = function(shipcharge) {
	var shipchargeDS = server.datasources.shipcharge;

	// Can't actually register the model until after the SOAP connector is connected, so we wait for
	// the connected event and manually register it.
	//
	// See: https://docs.strongloop.com/display/public/LB/SOAP+connector#SOAPconnector-CreatingamodelfromaSOAPdatasource
	// and https://github.com/strongloop/loopback-connector-soap/issues/17 for more information
	shipchargeDS.once('connected', function shipchargeConnectorConnectedCallback () {
		shipcharge.amount = function (to, from, cb) {
			console.log("To: " + to);
			console.log("From: " + from);
			shipcharge.calcShipCharge(
				{
					to: to,
					from: from
				},
				function (err, response) {
					if (!err) {
						console.log('Shipping', response);
						response = {"amount": response.shipCharge.$value};
						cb(null, response);
					} else {
						cb(err, null);
					}
				}
			);
		};

		loopback.remoteMethod(
		    shipcharge.amount, {
		       accepts: [
		         {arg: 'to', type: 'string', required: true, http: {source: 'query'}},
				 {arg: 'from', type: 'string', required: true, http: {source: 'query'}}
		       ],
		       returns: {arg: 'result', type: 'object', root: true},
		       http: {verb: 'get', path: '/amount'}
		    }
		);

		// Manually register
		server.model(shipcharge);
	});
};
