'use strict'

ThreadsController = (ThreadsService, UserV3Service) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = removeBlanks threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  removeBlanks = (threads) ->
    noBlanks = []

    for thread in threads
      noBlanks.push thread if thread.messsages.length

    noBlanks

  activate = ->
    UserV3Service.getCurrentUser (response) ->
      ThreadsService.get response.handle, onChange if response?.handle

    vm

  activate()

ThreadsController.$inject = ['ThreadsService', 'UserV3Service']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
