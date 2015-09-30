'use strict'

ThreadsController = ($scope, ThreadsService) ->
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
    $scope.$watch 'subscriberId', ->
      ThreadsService.get $scope.subscriberId, onChange if $scope.subscriberId.length

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService',]

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
