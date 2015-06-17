'use strict'

ThreadsController = ($scope, ThreadsService) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  activate = ->
    threadParams =
      subscriber: $scope.subscriber
      threadId: $scope.threadId

    ThreadsService.get threadParams, onChange

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
