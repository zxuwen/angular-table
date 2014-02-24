// Karma configuration
// Generated on Wed Feb 05 2014 13:15:20 GMT+0100 (CET)

module.exports = function(config) {
  config.set({

    // base path, that will be used to resolve files and exclude
    basePath: '',


    // frameworks to use
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      'http://code.angularjs.org/1.2.11/angular.min.js',
      'http://code.angularjs.org/1.2.11/angular-mocks.js',
      'http://underscorejs.org/underscore-min.js',

      'coffee/configuration/column_configuration.coffee',
      'coffee/configuration/table_configuration.coffee',

      'coffee/directives/table/setup/setup.coffee',
      'coffee/directives/table/setup/standard_setup.coffee',
      'coffee/directives/table/setup/paginated_setup.coffee',
      'coffee/directives/table/table.coffee',

      'coffee/directives/at_table.coffee',
      'coffee/directives/at_pagination.coffee',
      'coffee/directives/at_implicit.coffee',

      'test/test_helper.coffee',
      'test/*.coffee',
      'test/templates/**/*.html'
    ],


    // list of files to exclude
    exclude: [

    ],

    preprocessors: {
      'coffee/**/**/*.coffee': ['coffee'],
      'test/*.coffee': ['coffee'],
      'test/templates/**/*.html': ['ng-html2js']
    },

    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],


    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000,


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false
  });
};
