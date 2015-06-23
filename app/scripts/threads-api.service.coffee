'use strict'

transformResponse = (response) ->
  parsed = JSON.parse response

  parsed?.result?.content || {}

srv = ($resource, API_URL) ->
  # url     = API_URL + '/threads/:id'
  url = 'http://192.168.1.189:8080/v3/threads/:id'

  params  =
    id        : '@id'
    subscriber: '@subscriber'

  actions =
    query:
      method           :'GET'
      isArray          : false
      transformResponse: transformResponse
    get:
      method           :'GET'
      isArray          : false
      transformResponse: transformResponse

  $resource url, params, actions

srv.$inject = ['$resource', 'API_URL']

angular.module('appirio-tech-messaging').factory 'ThreadsAPIService', srv
