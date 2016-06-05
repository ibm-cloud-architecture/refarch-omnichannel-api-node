var loopback = require('loopback');
var boot = require('loopback-boot');
var explorer = require('loopback-component-explorer');

var app = module.exports = loopback();

app.start = function () {
	// start the web server
	return app.listen(function () {
		app.emit('started');
		var baseUrl = app.get('url').replace(/\/$/, '');

		console.log('Web server listening at: %s', baseUrl);

		// Init the explorer
		explorer(app, { basePath: '/api', mountPath: '/explorer' });
	});
};

// Bootstrap the application, configure models, datasources, and middleware.
// Sub-apps like REST API are mounted via boot scripts.
boot(app, __dirname, function (err) {
	if (err) throw err;

	// start the server if `$ node server.js`
	if (require.main === module)
		app.start();
});
