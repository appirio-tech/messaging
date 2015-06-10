'use strict'

createdAt = null

srv = (MessagesAPIService) ->
  retrieveCreatedAt = (params, displayCreatedAt) ->
  	queryParams =
  		filter: 'workId=' + params.workId

  	resource = MessagesAPIService.query queryParams

  	resource.$promise.then (response) ->
      buildMessages response, displayCreatedAt

  	resource.$promise.catch ->

  	resource.$promise.finally ->

  buildMessages = (messages, displayCreatedAt) ->
    displayCreatedAt? messages

  retrieveCreatedAt: retrieveCreatedAt

srv.$inject = ['MessagesAPIService']

angular.module('appirio-tech-messaging').factory 'MessagingService', srv
