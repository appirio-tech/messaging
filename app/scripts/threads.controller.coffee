'use strict'

ThreadsController = ($scope, ThreadsService, UserV3Service) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = removeBlanks threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  removeBlanks = (threads) ->
    noBlanks = []

    for thread in threads
      noBlanks.push thread if thread.messages.length

    noBlanks

  activate = ->
    UserV3Service.getCurrentUser (response) ->
      ThreadsService.get response.id, onChange if response?.id

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService', 'UserV3Service']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
