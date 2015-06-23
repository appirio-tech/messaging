'use strict'

ThreadsController = ($scope, ThreadsService) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  getThread = (subscriber) ->
    param =
      subscriberId: subscriber

    ThreadsService.get param, onChange

  activate = ->
    $scope.$watch 'subscriber', ->
      getThread $scope.subscriber if $scope.subscriber?.length

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
