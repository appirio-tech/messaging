'use strict'

transformResponse = (response) ->
  parsed = JSON.parse response

  parsed?.result?.content || []

srv = ($resource, API_URL) ->
  # url = API_URL + '/messages/:id'
  url = 'http://localhost:8080/v3/messages/:id'

  params =
    id: '@id'

  methods =
    put:
      method: 'PUT'

  $resource url, {}, methods

srv.$inject = ['$resource', 'API_URL']

angular.module('appirio-tech-messaging').factory 'MessagesAPIService', srv
