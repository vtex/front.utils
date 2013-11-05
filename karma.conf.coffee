module.exports = (config) ->
	config.set
		files: [
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