require './scripts/messaging.module'

# require.context './images/', true, /^(.*\.(svg$))[^.]*$/igm


requireContextFiles = (files) ->
  paths = files.keys()

  for path in paths
    files path

styles = require.context './styles/', true, /^(.*\.(scss$))[^.]*$/igm

requireContextFiles styles

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

templateCache.$inject = ['$templateCache']

angular.module('appirio-tech-ng-messaging').run templateCache

