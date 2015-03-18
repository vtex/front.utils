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
      options:
        configFile: 'karma.conf.coffee'
      ci:
        singleRun: true
      dev:
        singleRun: false

    uglify:
      main:
        options:
          sourceMap: true
          sourceMapIncludeSources: true
        files: [{
          expand: true,
          cwd: 'build/',
          src: '**/*.js',
          dest: 'build/'
        }]

    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee']

    shell:
      cp:
        command: "aws s3 cp --recursive #{pkg.deploy} s3://vtex-io-us/#{pkg.name}/"
      # O Bucket vtex-io usa a região São Paulo, para fallback em caso de problemas com vtex-io-us
      cp_br:
        command: "aws s3 cp --recursive #{pkg.deploy} s3://vtex-io/#{pkg.name}/"

  tasks =
    # Building block tasks
    build: ['clean', 'coffee', 'copy:pkg']
    min: ['uglify'] # minifies files
    # Deploy tasks
    dist: ['build', 'min', 'copy:deploy'] # Dist - minifies files
    test: ['karma:ci']
    devtest: ['karma:dev']
    vtex_deploy: ['shell:cp', 'shell:cp_br']
    # Development tasks
    dev: ['nolr', 'build', 'watch']
    default: ['build', 'connect', 'watch']
    devmin: ['build', 'min', 'connect:http:keepalive'] # Minifies files and serve

  # Project configuration.
  grunt.config.init defaultConfig
  grunt.config.merge customConfig
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-' and name isnt 'grunt-vtex'
  grunt.registerTask taskName, taskArray for taskName, taskArray of tasks
