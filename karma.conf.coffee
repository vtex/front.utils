module.exports = (config) ->
	config.set
		files: [
			'bower_components/underscore/underscore.js',
			'build/js/vtex-utils.js',
			'build/js/*.js',
			'spec/**/*.coffee'
		]
		browsers: [
			'PhantomJS'
		]
		preprocessors:
			"**/*.coffee": "coffee"
		frameworks: ["jasmine"]