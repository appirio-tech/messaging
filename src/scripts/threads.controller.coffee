'use strict'

ThreadsController = ($scope, ThreadsAPIService) ->
  vm = this
  vm.loadingThreads = false

  removeExtraThreads = (threads) ->
    filteredThreads = []
    # only show threads with messages and between copilot & user
    if threads
      for thread in threads
        filteredThreads.push thread if thread.messages?.length && (thread.id?.substr(0, 10) == 'threadfor-')

      filteredThreads

  getUserThreads =  ->
    params =
      subscriberId: $scope.subscriberId

    vm.loadingThreads = true

    resource = ThreadsAPIService.get params

    resource.$promise.then (response) ->
      vm.threads          = removeExtraThreads response?.threads

      unreadCounts = vm.threads?.map (thread) ->
        thread.unreadCount

      vm.totalUnreadCount = unreadCounts?.reduce (previous, next) ->
        previous + next
      , 0

      # vm.totalUnreadCount = response?.totalUnreadCount

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
