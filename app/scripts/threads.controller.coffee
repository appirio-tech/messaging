'use strict'

ThreadsController = (ThreadsService, UserV3Service) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  activate = ->
    UserV3Service.getCurrentUser (response) ->
      ThreadsService.get response.handle, onChange if response?.handle

    vm

  activate()

ThreadsController.$inject = ['ThreadsService', 'UserV3Service']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
