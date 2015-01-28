GruntVTEX = require 'grunt-vtex'

module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'

  defaultConfig = GruntVTEX.generateConfig grunt, pkg

  # Add custom configuration here as needed
  customConfig =
    coffee:
      main:
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: "build/<%= relativePath %>/"
          rename: (path, filename) ->
            path + filename.replace("coffee", "js")
        ]

    coffeelint:
      main:
        src: ['src/**/*.coffee']

    karma:
      unit:
        configFile: 'karma.conf.coffee'

    uglify:
      underscore:
        files:
          'build/<%= relativePath %>/underscore/underscore-extensions.min.js': 'build/<%= relativePath %>/underscore/underscore-extensions.js'

  tasks =
    # Building block tasks
    build: ['clean', 'coffee']
    min: ['uglify'] # minifies files
    # Deploy tasks
    dist: ['build', 'min', 'copy:deploy'] # Dist - minifies files
    test: ['karma']
    vtex_deploy: ['shell:cp', 'shell:cp_br']
    # Development tasks
    default: ['build', 'connect', 'watch']
    devmin: ['build', 'min', 'connect:http:keepalive'] # Minifies files and serve

  # Project configuration.
  grunt.config.init defaultConfig
  grunt.config.merge customConfig
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-' and name isnt 'grunt-vtex'
  grunt.registerTask taskName, taskArray for taskName, taskArray of tasks
