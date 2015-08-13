'use strict'

srv = ($resource, API_URL) ->
  url     = API_URL + '/v2/users/:handle'
  params  = handle: '@handle'

  $resource url, params

srv.$inject = ['$resource', 'API_URL']

angular.module('appirio-tech-messaging').factory 'UserAPIService', srv
