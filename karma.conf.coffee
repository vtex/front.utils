module.exports = (config) ->
  config.set
    browsers: ['PhantomJS']
    frameworks: ['mocha', 'chai']
    files: [
      'http://io.vtex.com.br/front-libs/underscore/1.5.2/underscore-min.js',
      'src/**/*.coffee',
      'spec/**/*.coffee'
    ]
    reporters: ['mocha']
    client:
      mocha:
        ui: 'bdd'
    preprocessors:
      '**/*.coffee': ['coffee']
