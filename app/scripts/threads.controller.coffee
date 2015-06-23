'use strict'

ThreadsController = ($scope, ThreadsService) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  getThread =  ->
    threadParams =
      subscriber: $scope.subscriber

    ThreadsService.get threadParams, onChange

  activate = ->
    $scope.$watch 'subscriber', ->
      getThread()

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
