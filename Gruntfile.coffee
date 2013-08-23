module.exports = (grunt) ->
	pkg = grunt.file.readJSON('package.json')

	grunt.initConfig
		clean:
			main: ['build']
			dist: ['build', 'doc', 'dist']

		copy:
			main:
				expand: true
				cwd: 'src/'
				src: ['**', '!coffee/**', '!**/*.less']
				dest: 'build/<%= relativePath %>'

		coffee:
			main:
				expand: true
				cwd: 'src/coffee'
				src: ['**/*.coffee']
				dest: 'build/<%= relativePath %>/js/'
				ext: '.js'

		uglify:
			dist:
				files:
					'dist/vtex-utils.min.js': 'dist/vtex-utils.js'

		karma:
			options:
				configFile: 'karma.conf.coffee'
			unit:
				background: true
			single:
				singleRun: true

		shell:
			codo:
				command: 'codo'
				options:
					stdout: true

		connect:
			dev:
				options:
					port: 9001
					base: 'build/'

		watch:
			options:
				livereload: true
			main:
				files: ['src/**/*.coffee', 'spec/**/*.coffee']
				tasks: ['dev', 'karma:unit:run']

	grunt.loadNpmTasks name for name of pkg.dependencies when name[0..5] is 'grunt-'

	grunt.registerTask 'test', ['clean:main', 'copy', 'coffee', 'uglify', 'karma:single']