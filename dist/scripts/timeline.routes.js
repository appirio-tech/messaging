(function() {
  'use strict';
  var config;

  config = function($stateProvider) {
    var state;
    state = {
      url: '/timeline/:workId',
      title: 'Timeline',
      controller: 'TimelineController',
      controllerAs: 'vm',
      templateUrl: 'views/timeline.html'
    };
    return $stateProvider.state('timeline', state);
  };

  config.$inject = ['$stateProvider'];

  angular.module('appirio-tech-timeline').config(config).run();

}).call(this);
