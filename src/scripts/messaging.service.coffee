'use strict'

srv = (MessagesAPIService, ThreadsAPIService) ->
  getThreads = (params, onChange) ->
    resource = ThreadsAPIService.get params

    resource.$promise.then (response) ->
      onChange? response

    resource.$promise.catch ->

    resource.$promise.finally ->


  markMessageRead = (message, params) ->
    queryParams =
      id: message.id

    putParams =
      read        : true
      subscriberId: params.subscriberId

    MessagesAPIService.put queryParams, putParams

  postMessage = (params, message, onChange) ->
    resource = MessagesAPIService.post message

    resource.$promise.then (response) ->
      onChange? message

    resource.$promise.catch (response) ->

    resource.$promise.finally ->
      # onChange? message

  getThreads:  getThreads
  postMessage: postMessage
  markMessageRead: markMessageRead

srv.$inject = [
  'MessagesAPIService'
  'ThreadsAPIService'
]

angular.module('appirio-tech-ng-messaging').factory 'MessagingService', srv
