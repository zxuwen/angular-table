// Karma configuration
// Generated on Thu Jul 04 2013 23:17:10 GMT+0200 (CEST)


// base path, that will be used to resolve files and exclude
basePath = '';


// list of files / patterns to load in the browser
files = [
  JASMINE,
  JASMINE_ADAPTER,
  "http://code.jquery.com/jquery-1.10.1.min.js",
  "http://code.angularjs.org/1.1.5/angular.min.js",
  "http://code.angularjs.org/1.1.5/angular-mocks.js",
  "http://underscorejs.org/underscore-min.js",
  // important to load this first, because it contains the module definition
  "coffee/atTable.coffee",
  "coffee/*.coffee",
  "test/test_helper.coffee",
  "test/*.coffee",
  "test/templates/*.html",
  "test/templates/*/*.html"
];

preprocessors = {
  "coffee/*.coffee": "coffee",
  "test/*.coffee": "coffee",
  "test/templates/*.html": "html2js",
  "test/templates/*/*.html": "html2js"
};

// list of files to exclude
exclude = [

];


// test results reporter to use
// possible values: 'dots', 'progress', 'junit'
reporters = ['progress'];


// web server port
port = 9876;


// cli runner port
runnerPort = 9100;


// enable / disable colors in the output (reporters and logs)
colors = true;


// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;


// enable / disable watching file and executing tests whenever any file changes
autoWatch = true;


// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari (only Mac)
// - PhantomJS
// - IE (only Windows)
browsers = ['Chrome'];


// If browser does not capture in given timeout [ms], kill it
captureTimeout = 60000;


// Continuous Integration mode
// if true, it capture browsers, run tests and exit
singleRun = false;
