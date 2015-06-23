'use strict'

ThreadsController = (ThreadsService, UserV3Service) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  getThreads = (subscriber) ->
    param =
      subscriberId: subscriber

    ThreadsService.get param, onChange

  activate = ->
    UserV3Service.getCurrentUser (response) ->
      getThreads response.handle if response?.handle

    vm

  activate()

ThreadsController.$inject = ['ThreadsService', 'UserV3Service']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
