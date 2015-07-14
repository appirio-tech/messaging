configs =
  tempFolder: '.tmp'
  appFolder : 'app'
  distFolder: 'dist'
  __dirname : __dirname

configs.templateCache =
  files : [
    '.tmp/views/messaging.directive.html'
    '.tmp/views/threads.directive.html'
  ]
  root  : 'views/'
  module: 'appirio-tech-messaging'


### END CONFIG ###
loadTasksModule = require __dirname + '/node_modules/appirio-gulp-tasks/load-tasks.coffee'

loadTasksModule.loadTasks configs
