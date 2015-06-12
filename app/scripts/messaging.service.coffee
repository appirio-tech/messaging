'use strict'

srv = (MessagesAPIService, AVATAR_URL, UserAPIService) ->
  getMessages = (params, onChange) ->
    queryParams =
      filter : 'workId=' + params.workId
      orderBy: 'createdAt'

    messaging =
      messages: []
      avatars : {}

    resource = MessagesAPIService.query queryParams

    resource.$promise.then (response) ->
      messaging.messages = response

      for message in messaging.messages
        buildAvatar message.createdBy, messaging, onChange

      onChange? messaging

    resource.$promise.catch ->

    resource.$promise.finally ->

  buildAvatar = (handle, messaging, onChange) ->
    unless messaging.avatars[handle]
      userParams =
        handle: handle

      user = UserAPIService.get userParams

      user.$promise.then (response) ->
        messaging.avatars[handle] = AVATAR_URL + response?.photoLink

        onChange? messaging

      user.$promise.catch ->
        # need handle error

      user.$promise.finally ->
        # need handle finally

  postMessage = (message, onChange) ->
    resource = MessagesAPIService.save message

    resource.$promise.then (response) ->

    resource.$promise.catch ->

    resource.$promise.finally ->

  getMessages: getMessages
  postMessage: postMessage

srv.$inject = ['MessagesAPIService', 'AVATAR_URL', 'UserAPIService']

angular.module('appirio-tech-messaging').factory 'MessagingService', srv

