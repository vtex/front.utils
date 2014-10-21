module.exports = (config) ->
	config.set
		files: [
			'bower_components/underscore/underscore.js',
			'src/**/*.coffee',
			'spec/**/*.coffee'
		]
		browsers: [
			'PhantomJS'
		]
		preprocessors:
			"**/*.coffee": "coffee"
		frameworks: ["jasmine"]
