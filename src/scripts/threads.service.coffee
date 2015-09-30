'use strict'

srv = (ThreadsAPIService) ->
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

      onChange? threadsVm

    resource.$promise.catch ->

    resource.$promise.finally ->

  get: get

srv.$inject = ['ThreadsAPIService']

angular.module('appirio-tech-ng-messaging').factory 'ThreadsService', srv
