'use strict'

transformResponse = (response) ->
  parsed = JSON.parse response

  parsed?.result?.content || []

srv = ($resource, API_URL) ->
  url     = API_URL + '/messages'

  $resource url

srv.$inject = ['$resource', 'API_URL']

angular.module('appirio-tech-messaging').factory 'MessagesAPIService', srv
