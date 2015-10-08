'use strict'

ThreadsController = ($scope, ThreadsService, MessagingService) ->
  vm = this

  onThreadsChange = (threadsVm) ->
    vm.threads          = removeBlanks threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount

  removeBlanks = (threads) ->
    noBlanks = []

    for thread in threads
      noBlanks.push thread if thread.messages.length

    noBlanks

  getUserThreads =  ->
    if $scope.subscriberId
      params =
        subscriberId: $scope.subscriberId

      MessagingService.getThreads params, onThreadsChange

  activate = ->
    $scope.$watch 'subscriberId', ->
      getUserThreads()

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService', 'MessagingService']

angular.module('appirio-tech-ng-messaging').controller 'ThreadsController', ThreadsController
