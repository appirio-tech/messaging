'use strict'

srv = (MessagesAPIService, AVATAR_URL, UserAPIService, ThreadsAPIService) ->
  getMessages = (params, onChange) ->
    messaging =
      messages: []
      avatars : {}

    resource = ThreadsAPIService.get params

    resource.$promise.then (response) ->
      messaging.messages = response?.messages

      for message in messaging.messages
        buildAvatar message.publisherId, messaging, onChange

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

  buildAvatar = (handle, messaging, onChange) ->
    unless messaging.avatars[handle]
      params =
        handle: handle

      user = UserAPIService.get params

      user.$promise.then (response) ->
        messaging.avatars[handle] = AVATAR_URL + response?.photoLink

        onChange? messaging

      user.$promise.catch (response) ->
        # need handle error

      user.$promise.finally ->
        # need handle finally

  postMessage = (message, onChange) ->
    resource = MessagesAPIService.save message

    resource.$promise.then (response) ->

    resource.$promise.catch (response) ->

    resource.$promise.finally ->

  getMessages: getMessages
  postMessage: postMessage

srv.$inject = [
  'MessagesAPIService'
  'AVATAR_URL'
  'UserAPIService'
  'ThreadsAPIService'
]

angular.module('appirio-tech-messaging').factory 'MessagingService', srv
