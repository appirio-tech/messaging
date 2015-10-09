'use strict'

ThreadsController = ($scope, ThreadsAPIService) ->
  vm = this
  vm.loadingThreads = false

  removeBlanks = (threads) ->
    noBlanks = []

    for thread in threads
      noBlanks.push thread if thread.messages.length

    noBlanks

  getUserThreads =  ->
    params =
      subscriberId: $scope.subscriberId

    vm.loadingThreads = true

    resource = ThreadsAPIService.get params

    resource.$promise.then (response) ->
      vm.threads          = removeBlanks response.threads
      vm.totalUnreadCount = response.totalUnreadCount

    resource.$promise.catch ->

    resource.$promise.finally ->
      vm.loadingThreads = false

  activate = ->
    $scope.$watch 'subscriberId', ->
      getUserThreads()

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsAPIService']

angular.module('appirio-tech-ng-messaging').controller 'ThreadsController', ThreadsController
