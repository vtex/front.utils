module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    clean:
      main: ['dist']

    coffee:
      main:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'dist/<%= relativePath %>/'
        ext: '.js'

    uglify:
      dist:
        files:
          'dist/vtex-context.min.js': 'dist/vtex-context.js'
          'dist/vtex-utils.min.js': 'dist/vtex-utils.js'

    karma:
      options:
        configFile: 'karma.conf.coffee'
      unit:
        autoWatch: true
      single:
        singleRun: true

  grunt.loadNpmTasks name for name of pkg.dependencies when name[0..5] is 'grunt-'

  grunt.registerTask 'test',    ['karma:single']
  grunt.registerTask 'dist',    ['test', 'coffee:main', 'uglify']
  grunt.registerTask 'default', ['dist']
