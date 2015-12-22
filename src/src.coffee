require.context './styles/', true, /^(.*\.(scss$))[^.]*$/igm
# require.context './images/', true, /^(.*\.(svg$))[^.]*$/igm

require 'appirio-tech-ng-file-upload'
require './scripts/messaging.module'

requireContextFiles = (files) ->
  paths = files.keys()

  for path in paths
    files path

require './scripts/messaging.directive'
require './scripts/messaging.controller'

views     = require.context './views/', true, /^(.*\.(jade$))[^.]*$/igm
viewPaths = views.keys()

templateCache = ($templateCache) ->
  for viewPath in viewPaths
    viewPathClean = viewPath.split('./').pop()

    # TODD: bug if .jade occurs more often than once
    viewPathCleanHtml = viewPathClean.replace '.jade', '.html'

    $templateCache.put "views/#{viewPathCleanHtml}", views(viewPath)()

templateCache.$nject = ['$templateCache']

angular.module('appirio-tech-ng-messaging').run templateCache

