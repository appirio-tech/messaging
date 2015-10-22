(function() {
  'use strict';
  var dependencies;

  dependencies = ['ui.router', 'ngResource', 'app.constants', 'duScroll', 'appirio-tech-ng-ui-components', 'appirio-tech-ng-api-services'];

  angular.module('appirio-tech-ng-messaging', dependencies);

}).call(this);

(function() {
  'use strict';
  var MessagingController;

  MessagingController = function($scope, MessagesAPIService, ThreadsAPIService, InboxesAPIService, MessageUpdateAPIService) {
    var activate, getThread, markMessageRead, onMessageChange, orderMessagesByCreationDate, sendMessage, vm;
    vm = this;
    vm.currentUser = null;
    vm.activeThread = null;
    vm.sending = false;
    vm.loadingThreads = false;
    vm.loadingMessages = false;
    vm.workId = $scope.workId;
    vm.threadId = $scope.threadId;
    vm.subscriberId = $scope.subscriberId;
    orderMessagesByCreationDate = function(messages) {
      var orderedMessages;
      orderedMessages = messages != null ? messages.sort(function(previous, next) {
        return new Date(previous.createdAt) - new Date(next.createdAt);
      }) : void 0;
      return orderedMessages;
    };
    onMessageChange = function(message) {
      var ref;
      if ((ref = vm.thread) != null) {
        ref.messages.push(message);
      }
      vm.newMessage = '';
      return $scope.showLast = 'scroll';
    };
    markMessageRead = function(message) {
      var putParams, queryParams, resource;
      queryParams = {
        threadId: vm.threadId,
        messageId: message.id
      };
      putParams = {
        param: {
          readFlag: true,
          subscriberId: $scope.subscriberId
        }
      };
      resource = MessageUpdateAPIService.put(queryParams, putParams);
      resource.$promise.then(function(response) {});
      return resource.$promise["finally"](function() {});
    };
    activate = function() {
      vm.newMessage = '';
      $scope.$watch('subscriberId', function() {
        return getThread();
      });
      vm.sendMessage = sendMessage;
      return vm;
    };
    getThread = function() {
      var params, resource;
      if ($scope.subscriberId) {
        params = {
          threadId: vm.threadId
        };
        vm.loadingThreads = true;
        resource = InboxesAPIService.get(params);
        resource.$promise.then(function(response) {
          var lastMessage;
          vm.thread = response;
          vm.thread.messages = orderMessagesByCreationDate(vm.thread.messages);
          if (vm.thread.unreadCount > 0) {
            lastMessage = vm.thread.messages[vm.thread.messages.length - 1];
            return markMessageRead(lastMessage);
          }
        });
        resource.$promise["catch"](function() {});
        return resource.$promise["finally"](function() {
          return vm.loadingThreads = false;
        });
      }
    };
    sendMessage = function() {
      var message, resource;
      if (vm.newMessage.length && vm.thread) {
        message = {
          param: {
            publisherId: $scope.subscriberId,
            threadId: vm.threadId,
            body: vm.newMessage,
            attachments: []
          }
        };
        vm.sending = true;
        resource = MessagesAPIService.post(message);
        resource.$promise.then(function(response) {
          return onMessageChange(message.param);
        });
        resource.$promise["catch"](function(response) {});
        return resource.$promise["finally"](function() {
          return vm.sending = false;
        });
      }
    };
    return activate();
  };

  MessagingController.$inject = ['$scope', 'MessagesAPIService', 'ThreadsAPIService', 'InboxesAPIService', 'MessageUpdateAPIService'];

  angular.module('appirio-tech-ng-messaging').controller('MessagingController', MessagingController);

}).call(this);

(function() {
  'use strict';
  var directive;

  directive = function() {
    var link;
    link = function(scope, element, attrs) {
      var showLast;
      showLast = function(newValue, oldValue) {
        var $messageList, bottom, messageList, uls;
        if (newValue) {
          scope.showLast = false;
          uls = element.find('ul');
          messageList = uls[0];
          $messageList = angular.element(messageList);
          bottom = messageList.scrollHeight;
          if (newValue === 'scroll') {
            return $messageList.scrollTopAnimated(bottom);
          } else {
            return $messageList.scrollTop(bottom);
          }
        }
      };
      showLast(true);
      return scope.$watch('showLast', showLast);
    };
    return {
      restrict: 'E',
      templateUrl: 'views/messaging.directive.html',
      link: link,
      controller: 'MessagingController',
      controllerAs: 'vm',
      scope: {
        threadId: '@threadId',
        workId: '@workId',
        subscriberId: '@subscriberId'
      }
    };
  };

  directive.$inject = [];

  angular.module('appirio-tech-ng-messaging').directive('messaging', directive);

}).call(this);

(function() {
  'use strict';
  var directive;

  directive = function() {
    return {
      restrict: 'E',
      templateUrl: 'views/threads.directive.html',
      controller: 'ThreadsController',
      controllerAs: 'vm',
      scope: {
        subscriberId: '@subscriberId'
      }
    };
  };

  directive.$inject = [];

  angular.module('appirio-tech-ng-messaging').directive('threads', directive);

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function(ThreadsAPIService) {
    var get;
    get = function(subscriberId, onChange) {
      var queryParams, resource, threadsVm;
      queryParams = {
        subscriberId: subscriberId
      };
      threadsVm = {
        threads: [],
        totalUnreadCount: {},
        avatars: {}
      };
      resource = ThreadsAPIService.query(queryParams);
      resource.$promise.then(function(response) {
        threadsVm.threads = response.threads;
        return typeof onChange === "function" ? onChange(threadsVm) : void 0;
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    return {
      get: get
    };
  };

  srv.$inject = ['ThreadsAPIService'];

  angular.module('appirio-tech-ng-messaging').factory('ThreadsService', srv);

}).call(this);

(function() {
  'use strict';
  var ThreadsController;

  ThreadsController = function($scope, ThreadsAPIService) {
    var activate, getUserThreads, removeBlanks, vm;
    vm = this;
    vm.loadingThreads = false;
    removeBlanks = function(threads) {
      var i, len, noBlanks, ref, thread;
      noBlanks = [];
      if (threads) {
        for (i = 0, len = threads.length; i < len; i++) {
          thread = threads[i];
          if (thread != null ? (ref = thread.messages) != null ? ref.length : void 0 : void 0) {
            noBlanks.push(thread);
          }
        }
        return noBlanks;
      }
    };
    getUserThreads = function() {
      var params, resource;
      params = {
        subscriberId: $scope.subscriberId
      };
      vm.loadingThreads = true;
      resource = ThreadsAPIService.get(params);
      resource.$promise.then(function(response) {
        vm.threads = removeBlanks(response != null ? response.threads : void 0);
        return vm.totalUnreadCount = response != null ? response.totalUnreadCount : void 0;
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {
        return vm.loadingThreads = false;
      });
    };
    activate = function() {
      $scope.$watch('subscriberId', function() {
        return getUserThreads();
      });
      return vm;
    };
    return activate();
  };

  ThreadsController.$inject = ['$scope', 'ThreadsAPIService'];

  angular.module('appirio-tech-ng-messaging').controller('ThreadsController', ThreadsController);

}).call(this);

angular.module("appirio-tech-ng-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.directive.html","<p>You have {{vm.thread.messages.length}} messages with {{vm.thread.messages[0].publisher.handle}}</p><ul class=\"messages flex-grow\"><li ng-repeat=\"message in vm.thread.messages track by $index\"><avatar avatar-url=\"{{ message.publisher.avatar }}\"></avatar><div class=\"message elevated-bottom\"><a href=\"#\" class=\"name\">{{message.publisher.handle}}</a><time>{{ message.createdAt | timeLapse }}</time><p ng-if=\"message.publisher.role != null\" class=\"title\">{{message.publisher.role}}</p><p>{{ message.body }}</p><ul class=\"attachments\"><li ng-repeat=\"attachment in message.attachments track by $index\"><a href=\"#\">{{ message.attachments.originalUrl }}</a></li></ul><a ng-if=\"message.attachments.length &gt; 0\" class=\"download\"><div class=\"icon download smallest\"></div><p>Download all images</p></a></div></li><a id=\"messaging-bottom-{{ vm.threadId }}\"></a></ul><div class=\"respond\"><form ng-submit=\"vm.sendMessage()\"><textarea placeholder=\"Send a message&hellip;\" ng-model=\"vm.newMessage\"></textarea><button type=\"submit\" ng-hide=\"vm.sending\" class=\"wider action\">reply</button><button disabled=\"disabled\" ng-show=\"vm.sending\" class=\"wider action\">sending...</button></form></div>");
$templateCache.put("views/threads.directive.html","<ul><li ng-repeat=\"thread in vm.threads track by $index\"><a ui-sref=\"messaging({ id: thread.id.substr(10), threadId: thread.id })\" ng-class=\"{unread: thread.unreadCount &gt; 0}\"><div class=\"app-name\">{{thread.subject}}</div><div class=\"sender\"><avatar avatar-url=\"{{ thread.publishers[0].avatar }}\"></avatar><div class=\"name\">{{thread.publishers[0]}}</div><time>{{ thread.messages[thread.messages.length -1].createdAt | timeLapse }}</time></div><p class=\"message\">{{ thread.messages[thread.messages.length -1].body }}</p></a></li></ul><div ng-show=\"vm.threads.length == 0\" class=\"none\">None</div>");}]);