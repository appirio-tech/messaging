(function() {
  'use strict';
  angular.module('appirio-tech-messaging', ['ui.router', 'ngResource', 'app.constants']);

}).call(this);

angular.module("appirio-tech-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.html","<h1>Messaging</h1><messaging thread-id=\"123\"></messaging>");}]);
(function() {
  'use strict';
  var MessagingController;

  MessagingController = function(MessagingService) {
    var activate, vm;
    vm = this;
    vm.greetings = null;
    activate = function() {
      return vm.greetings = 'Hello World!';
    };
    activate();
    return vm;
  };

  MessagingController.$inject = ['MessagingService'];

  angular.module('appirio-tech-messaging').controller('MessagingController', MessagingController);

}).call(this);

(function() {
  'use strict';
  var directive;

  directive = function(MessagingService) {
    var link;
    link = function() {};
    return {
      restrict: 'E',
      templateUrl: 'views/messaging.directive.html',
      link: link
    };
  };

  directive.$inject = ['MessagingService'];

  angular.module('appirio-tech-messaging').directive('messaging', directive);

}).call(this);

(function() {
  'use strict';
  var config;

  config = function($stateProvider) {
    var key, results, state, states;
    states = {};
    states['messaging'] = {
      url: '/messaging/:id',
      title: 'Messaging',
      controller: 'MessagingController',
      controllerAs: 'vm',
      templateUrl: 'views/messaging.html'
    };
    states['messaging-widget'] = {
      url: '/messaging-widget/:id',
      title: 'Messaging Widget',
      controller: 'MessagingController',
      controllerAs: 'vm',
      templateUrl: 'views/messaging-widget.html'
    };
    results = [];
    for (key in states) {
      state = states[key];
      results.push($stateProvider.state(key, state));
    }
    return results;
  };

  config.$inject = ['$stateProvider'];

  angular.module('appirio-tech-messaging').config(config).run();

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function() {
    return {};
  };

  srv.$inject = [];

  angular.module('appirio-tech-messaging').factory('MessagingService', srv);

}).call(this);

(function() {
  'use strict';
  var srv, transformResponse;

  transformResponse = function(response) {
    var parsed, ref;
    parsed = JSON.parse(response);
    return (parsed != null ? (ref = parsed.result) != null ? ref.content : void 0 : void 0) || [];
  };

  srv = function($resource, apiUrl) {
    var actions, params, url;
    url = apiUrl + 'messages';
    params = {
      filter: 'sourceObjectId%3D@workId'
    };
    actions = {
      query: {
        method: 'GET',
        isArray: true,
        transformResponse: transformResponse
      }
    };
    return $resource(url, params, actions);
  };

  srv.$inject = ['$resource', 'apiUrl'];

  angular.module('appirio-tech-messaging').factory('MessagesAPIService', srv);

}).call(this);
