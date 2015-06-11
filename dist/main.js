(function() {
  'use strict';
  angular.module('appirio-tech-messaging', ['ui.router', 'ngResource', 'app.constants']);

}).call(this);

angular.module("appirio-tech-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.html","<h1>Messaging</h1><hr/><messaging thread-id=\"123\"></messaging>");
$templateCache.put("views/messaging.directive.html","<ul class=\"messages\"><li ng-repeat=\"n in [42, 42, 43, 43] track by $index\"><div class=\"avatar\"></div><div class=\"message\"><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><ul class=\"attachments\"><li></li><li></li></ul><time>5 minutes ago</time></div></li></ul><form><textarea placeholder=\"Send a message&hellip;\"></textarea><button type=\"submit\" class=\"enter\">Enter</button><button type=\"button\" class=\"attach\"><div class=\"icon\"></div><span>Add Attachment</span></button></form>");
$templateCache.put("views/threads.directive.html","<ul><li ng-repeat=\"n in [42, 42, 43, 43] track by $index\"><header><h4>NASA - DTN Dashboard winner DTN Dashboard winner DTN Dashboard winner DTN Dashboard winner</h4><time>5 mins ago</time></header><main><div class=\"avatar\"></div><div class=\"message\"><div class=\"co-pilot\">Jimbo Co-pilot:</div><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p></div></main></li></ul>");}]);
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
    link = function(scope, element, attrs) {
      var messages;
      return messages = element.find('ul');
    };
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
  var directive;

  directive = function(MessagingService) {
    var link;
    link = function(scope, element, attrs) {
      var messages;
      return messages = element.find('ul');
    };
    return {
      restrict: 'E',
      templateUrl: 'views/threads.directive.html',
      link: link
    };
  };

  directive.$inject = ['MessagingService'];

  angular.module('appirio-tech-messaging').directive('threads', directive);

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