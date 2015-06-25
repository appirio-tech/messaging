'use strict'

srv = (ThreadsAPIService, AVATAR_URL, UserAPIService) ->
  get = (subscriberId, onChange) ->
    queryParams =
      subscriberId: subscriberId

    threadsVm =
      threads         : []
      totalUnreadCount: {}
      avatars         : {}

    resource = ThreadsAPIService.query queryParams

    resource.$promise.then (response) ->
      threadsVm.threads = response.threads

      publishers = []

      for thread in threadsVm.threads
        for message in thread.messages
          publishers.push message.publisherId

      for publisher in publishers
        buildAvatar publisher, threadsVm, onChange

      onChange? threadsVm

    resource.$promise.catch ->

    resource.$promise.finally ->

  buildAvatar = (handle, threadsVm, onChange) ->
    unless threadsVm.avatars[handle]
      userParams =
        handle: handle

      user = UserAPIService.get userParams

      user.$promise.then (response) ->
        threadsVm.avatars[handle] = AVATAR_URL + response?.photoLink

        onChange? threadsVm

      user.$promise.catch ->
        # need handle error

      user.$promise.finally ->
        # need handle finally

  get: get

srv.$inject = ['ThreadsAPIService', 'AVATAR_URL', 'UserAPIService']

angular.module('appirio-tech-messaging').factory 'ThreadsService', srv
