(function() {
  'use strict';
  var config;

  config = function($stateProvider) {
    var state;
    state = {
      url: '/messenger/:workId',
      title: 'Messenger',
      controller: 'MessengerController',
      controllerAs: 'vm',
      templateUrl: 'views/messenger.html'
    };
    return $stateProvider.state('messenger', state);
  };

  config.$inject = ['$stateProvider'];

  angular.module('appirio-tech-messenger').config(config).run();

}).call(this);
