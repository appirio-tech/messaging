'use strict'

transformResponse = (response) ->
  parsed = JSON.parse response

  parsed?.result?.content || []

srv = ($resource, apiUrl) ->
  url     = apiUrl + 'events'
  params  = filter: 'sourceObjectId%3D@workId'
  actions =
    query:
      method           :'GET'
      isArray          : true
      transformResponse: transformResponse

  $resource url, params, actions

srv.$inject = ['$resource', 'apiUrl']

angular.module('appirio-tech-timeline').factory 'TimelineAPIService', srv
