configs =
  __dirname : __dirname

configs.templateCache = []

configs.templateCache.push
  files : [
    '.tmp/views/*.directive.html'
  ]
  root  : 'views/'
  module: 'appirio-tech-ng-messaging'

configs.templateCache.push
  fileName: 'example-templates.js'
  files : [
    '.tmp/views/*.example.html'
  ]
  root  : 'views/'
  module: 'example'

### END CONFIG ###
loadTasksModule = require __dirname + '/node_modules/appirio-gulp-tasks/load-tasks.coffee'

loadTasksModule.loadTasks configs
