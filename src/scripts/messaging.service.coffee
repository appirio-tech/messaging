'use strict'

srv = (MessagesAPIService, ThreadsAPIService) ->
  getMessages = (params, onChange) ->
    messaging =
      messages: []
      avatars : {}

    resource = ThreadsAPIService.get params

    resource.$promise.then (response) ->
      messaging.messages = response?.messages

      for message in messaging.messages
        markMessageRead message, params

      onChange? messaging

    resource.$promise.catch ->

    resource.$promise.finally ->

  markMessageRead = (message, params) ->
    queryParams =
      id: message.id

    putParams =
      read        : true
      subscriberId: params.subscriberId
      threadId    : params.id

    MessagesAPIService.put queryParams, putParams

  postMessage = (message, onChange) ->
    resource = MessagesAPIService.save message

    resource.$promise.then (response) ->

    resource.$promise.catch (response) ->

    resource.$promise.finally ->

  getMessages: getMessages
  postMessage: postMessage

srv.$inject = [
  'MessagesAPIService'
  'ThreadsAPIService'
]

angular.module('appirio-tech-ng-messaging').factory 'MessagingService', srv
