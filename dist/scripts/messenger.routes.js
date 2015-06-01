(function() {
  'use strict';
  var config;

  config = function($stateProvider) {
    var state;
    state = {
      url: '/messaging/:workId',
      title: 'Messaging',
      controller: 'MessagingController',
      controllerAs: 'vm',
      templateUrl: 'views/messaging.html'
    };
    return $stateProvider.state('messaging', state);
  };

  config.$inject = ['$stateProvider'];

  angular.module('appirio-tech-messaging').config(config).run();

}).call(this);
