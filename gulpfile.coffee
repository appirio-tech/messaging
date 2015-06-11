configs =
  coffeeFiles     : 'app/**/*.coffee'
  jadeFiles       : 'app/**/*.jade'
  scssFiles       : 'app/**/*.scss'
  scssIncludePaths: require('appirio-work-styles').includePaths
  tempFolder      : '.tmp'
  appFolder       : 'app'
  distFolder      : 'dist'

configs.karma =
  coverage   : 'app/**/*.coffee'
  # Dont include coverage files
  coffeeFiles: [
    'tests/specs/**/*.coffee'
  ]
  files: [
    'bower_components/angular/angular.js'
    'bower_components/angular-mocks/angular-mocks.js'
    'bower_components/angular-resource/angular-resource.js'
    'bower_components/angular-ui-router/release/angular-ui-router.js'
    'bower_components/auto-config-fake-server/dist/scripts/auto-config-fake-server.js'
    'tests/specs/helper.coffee'
    '.tmp/scripts/constants.js'
    '.tmp/scripts/json-fixtures.js'
    'app/scripts/**/*.module.coffee'
    '.tmp/scripts/templates.js'
    'app/**/*.coffee'
    'tests/specs/**/*.coffee'
  ]

configs.fixtureFiles = [
  'bower_components/appirio-tech-api-schemas/v3-messages.json'
]

configs.templateCache =
  files : [
    '.tmp/views/messaging.html'
    '.tmp/views/messaging.directive.html'
    '.tmp/views/threads.directive.html'
  ]
  root  : 'views/'
  module: 'appirio-tech-messaging'

configs.constants =
  apiUrl        : 'https://api.topcoder-dev.com/v3/' # slash is grandfathered in from river
  API_URL_V2    : 'https://api.topcoder-dev.com/v2' # Should not end in slash
  AVATAR_URL    : 'http://www.topcoder.com' # Should not end in slash
  SUBMISSION_URL: 'https://studio.topcoder.com'

configs.coverageReporter =
  type: 'lcov'
  dir: 'coverage'

configs.buildFiles =
  concat:
    'main.js': [
      '.tmp/scripts/messaging.module.js',
      '.tmp/scripts/templates.js',
      '.tmp/scripts/messaging.controller.js',
      '.tmp/scripts/messaging.directive.js',
      '.tmp/scripts/threads.directive.js',
      '.tmp/scripts/messaging.service.js',
      '.tmp/scripts/messages-api.service.js'
    ]
    'main.css': [
      '.tmp/styles/messaging.css'
    ]

##
## Normally, you wouldnt need to edit below this line ##
##

gulpTaskPath             = './node_modules/appirio-gulp-tasks'
configs.karma.configFile = __dirname + '/' + gulpTaskPath + '/karma.conf.coffee'
configs.karma.basePath   = __dirname
pluginsPath              = gulpTaskPath + '/node_modules/gulp-load-plugins'
browserSyncPath          = gulpTaskPath + '/node_modules/browser-sync'
karmaPath                = gulpTaskPath + '/node_modules/karma'

gulpLoadPluginsOptions =
  config: __dirname + '/' + gulpTaskPath + '/package.json'

gulp          = require 'gulp'
plugins       = require pluginsPath
$             = plugins gulpLoadPluginsOptions
$.browserSync = require browserSyncPath
$.karma       = require(karmaPath).server

tasks = [
  'coffee'
  'jade'
  'scss'
  'clean'
  'serve'
  'build'
  'test'
  'ng-constant'
  'coveralls'
  'fixtures'
  'template-cache'
]

for task in tasks
  module = require(gulpTaskPath + '/tasks/' + task)
  module gulp, $, configs

gulp.task 'default', ['clean'], ->
  gulp.start 'build'
