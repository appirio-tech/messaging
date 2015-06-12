'use strict'

srv = ($resource, API_URL_V2) ->
  url     = API_URL_V2 + '/users/:handle'
  params  = handle: '@handle'

  $resource url, params

srv.$inject = ['$resource', 'API_URL_V2']

angular.module('appirio-tech-messaging').factory 'UserAPIService', srv
