module.exports = (config) ->
	config.set
		files: [
			JASMINE,
			JASMINE_ADAPTER,
			'build/js/vtex-utils.js',
			'build/js/*.js',
			'spec/**/*.coffee'
		]
		browsers: [
			'PhantomJS'
		]
		preprocessors:
			"**/*.coffee": "coffee"