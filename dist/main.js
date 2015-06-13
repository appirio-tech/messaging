(function() {
  'use strict';
  angular.module('appirio-tech-messaging', ['ui.router', 'ngResource', 'app.constants']);

}).call(this);

angular.module("appirio-tech-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.html","<messaging thread-id=\"123\" created-by=\"abc\"></messaging>");
$templateCache.put("views/messaging.directive.html","<ul class=\"messages\"><li ng-repeat=\"message in vm.messaging.messages track by $index\"><img ng-src=\"{{ vm.messaging.avatars[message.createdBy] }}\" class=\"avatar\"/><div class=\"message\"><p>{{ message.body }}</p><ul class=\"attachments\"><li ng-repeat=\"attachment in message.attachments track by $index\"><a href=\"#\">{{ message.attachments.originalUrl }}</a></li></ul><time>created at: {{ message.createdAt }}</time></div></li></ul><form ng-submit=\"vm.sendMessage()\"><textarea placeholder=\"Send a message&hellip;\" ng-model=\"vm.newMessage\"></textarea><button type=\"submit\" class=\"enter\">Enter</button><button type=\"button\" class=\"attach\"><div class=\"icon\"></div><span>Add Attachment</span></button></form>");
$templateCache.put("views/threads.directive.html","<ul><li ng-repeat=\"n in [42, 42, 43, 43] track by $index\"><header><h4>NASA - DTN Dashboard winner DTN Dashboard winner DTN Dashboard winner DTN Dashboard winner</h4><time>5 mins ago</time></header><main><div class=\"avatar\"></div><div class=\"message\"><div class=\"co-pilot\">Jimbo Co-pilot:</div><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p></div></main></li></ul>");}]);
(function() {
  'use strict';
  var MessagingController;

  MessagingController = function($scope, MessagingService, $stateParams) {
    var activate, onChange, sendMessage, vm;
    vm = this;
    onChange = function(messages) {
      return vm.messaging = messages;
    };
    activate = function() {
      var params;
      vm.messaging = {};
      vm.newMessage = '';
      params = {
        workId: $stateParams.id
      };
      MessagingService.getMessages(params, onChange);
      vm.sendMessage = sendMessage;
      return vm;
    };
    sendMessage = function() {
      var message;
      if (vm.newMessage.length) {
        message = {
          workId: $stateParams.id,
          threadId: $scope.threadId,
          createdBy: $scope.createdBy,
          createdAt: 'a minute ago',
          body: vm.newMessage,
          context: 'work',
          updatedBy: '',
          reads: [],
          attachments: []
        };
        vm.messaging.messages.push(message);
        MessagingService.postMessage(message, onChange);
        return vm.newMessage = '';
      }
    };
    return activate();
  };

  MessagingController.$inject = ['$scope', 'MessagingService', '$stateParams'];

  angular.module('appirio-tech-messaging').controller('MessagingController', MessagingController);

}).call(this);

(function() {
  'use strict';
  var directive;

  directive = function(MessagingService) {
    var link;
    link = function(scope, element, attrs) {};
    return {
      restrict: 'E',
      templateUrl: 'views/messaging.directive.html',
      link: link,
      controller: 'MessagingController',
      controllerAs: 'vm',
      scope: {
        threadId: '@threadId',
        createdBy: '@createdBy'
      }
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

  srv = function(MessagesAPIService, AVATAR_URL, UserAPIService) {
    var buildAvatar, getMessages, postMessage;
    getMessages = function(params, onChange) {
      var messaging, queryParams, resource;
      queryParams = {
        filter: 'workId=' + params.workId,
        orderBy: 'createdAt'
      };
      messaging = {
        messages: [],
        avatars: {}
      };
      resource = MessagesAPIService.query(queryParams);
      resource.$promise.then(function(response) {
        var i, len, message, ref;
        messaging.messages = response;
        ref = messaging.messages;
        for (i = 0, len = ref.length; i < len; i++) {
          message = ref[i];
          buildAvatar(message.createdBy, messaging, onChange);
        }
        return typeof onChange === "function" ? onChange(messaging) : void 0;
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    buildAvatar = function(handle, messaging, onChange) {
      var user, userParams;
      if (!messaging.avatars[handle]) {
        userParams = {
          handle: handle
        };
        user = UserAPIService.get(userParams);
        user.$promise.then(function(response) {
          messaging.avatars[handle] = AVATAR_URL + (response != null ? response.photoLink : void 0);
          return typeof onChange === "function" ? onChange(messaging) : void 0;
        });
        user.$promise["catch"](function() {});
        return user.$promise["finally"](function() {});
      }
    };
    postMessage = function(message, onChange) {
      var resource;
      resource = MessagesAPIService.save(message);
      resource.$promise.then(function(response) {});
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    return {
      getMessages: getMessages,
      postMessage: postMessage
    };
  };

  srv.$inject = ['MessagesAPIService', 'AVATAR_URL', 'UserAPIService'];

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
