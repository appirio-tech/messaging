(function() {
  'use strict';
  var dependencies;

  dependencies = ['ui.router', 'ngResource', 'app.constants', 'duScroll', 'appirio-tech-ng-ui-components', 'appirio-tech-ng-api-services'];

  angular.module('appirio-tech-ng-messaging', dependencies);

}).call(this);

(function() {
  'use strict';
  var MessagingController;

  MessagingController = function($scope, MessagesAPIService, ThreadsAPIService, MessageUpdateAPIService) {
    var activate, getUserThreads, markMessageRead, onMessageChange, orderMessagesByCreationDate, sendMessage, vm;
    vm = this;
    vm.currentUser = null;
    vm.activeThread = null;
    vm.sending = false;
    vm.loadingThreads = false;
    vm.loadingMessages = false;
    vm.workId = $scope.workId;
    vm.activateThread = function(thread) {
      var lastMessage, params;
      vm.activeThread = thread;
      thread.messages = orderMessagesByCreationDate(thread.messages);
      if (thread.unreadCount > 0) {
        params = {
          subscriberId: $scope.subscriberId
        };
        lastMessage = thread.messages[thread.messages.length - 1];
        return markMessageRead(lastMessage, params);
      }
    };
    orderMessagesByCreationDate = function(messages) {
      var orderedMessages;
      orderedMessages = messages.sort(function(previous, next) {
        return new Date(previous.createdAt) - new Date(next.createdAt);
      });
      return orderedMessages;
    };
    onMessageChange = function(message) {
      vm.activeThread.messages.push(message);
      vm.newMessage = '';
      return $scope.showLast = 'scroll';
    };
    markMessageRead = function(message, params) {
      var putParams, queryParams;
      queryParams = {
        workId: vm.workId,
        messageId: message.id
      };
      putParams = {
        param: {
          readFlag: true,
          subscriberId: params.subscriberId
        }
      };
      return MessageUpdateAPIService.put(queryParams, putParams);
    };
    activate = function() {
      vm.newMessage = '';
      $scope.$watch('subscriberId', function() {
        return getUserThreads();
      });
      vm.sendMessage = sendMessage;
      return vm;
    };
    getUserThreads = function() {
      var params, resource;
      if ($scope.subscriberId) {
        params = {
          subscriberId: $scope.subscriberId
        };
        vm.loadingThreads = true;
        resource = ThreadsAPIService.get(params);
        resource.$promise.then(function(response) {
          return vm.threads = response.threads;
        });
        resource.$promise["catch"](function() {});
        return resource.$promise["finally"](function() {
          return vm.loadingThreads = false;
        });
      }
    };
    sendMessage = function() {
      var message, params, resource;
      if (vm.newMessage.length && vm.activeThread) {
        message = {
          param: {
            publisherId: $scope.subscriberId,
            threadId: vm.activeThread.id,
            body: vm.newMessage,
            attachments: []
          }
        };
        params = {
          threadId: vm.activeThread.id
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

  MessagingController.$inject = ['$scope', 'MessagesAPIService', 'ThreadsAPIService', 'MessageUpdateAPIService'];

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
      var i, len, noBlanks, thread;
      noBlanks = [];
      for (i = 0, len = threads.length; i < len; i++) {
        thread = threads[i];
        if (thread.messages.length) {
          noBlanks.push(thread);
        }
      }
      return noBlanks;
    };
    getUserThreads = function() {
      var params, resource;
      params = {
        subscriberId: $scope.subscriberId
      };
      vm.loadingThreads = true;
      resource = ThreadsAPIService.get(params);
      resource.$promise.then(function(response) {
        vm.threads = removeBlanks(response.threads);
        return vm.totalUnreadCount = response.totalUnreadCount;
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

angular.module("appirio-tech-ng-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.directive.html","<div flush-height=\"flush-height\" class=\"flex center stretch\"><aside><loader ng-show=\"vm.loadingThreads\"></loader><h6>Project contributors</h6><ul><li ng-repeat=\"thread in vm.threads\"><a href=\"#\" ng-click=\"vm.activateThread(thread)\" ng-class=\"{active: vm.activeThread.id == thread.id}\"><avatar></avatar><div class=\"name-title\"><div class=\"name\">{{thread.publishers[0]}}</div><div class=\"title\">Development Co-Pilot</div></div><div class=\"notification\">{{thread.unreadCount}}</div></a></li></ul></aside><main class=\"flex column middle flex-grow\"><h1>Messaging</h1><p>You have {{vm.activeThread.messages.length}} messages with {{vm.activeThread.publishers[0]}}</p><ul class=\"messages flex-grow\"><li ng-repeat=\"message in vm.activeThread.messages track by $index\"><avatar avatar-url=\"{{ vm.activeThread[publisherId] }}\"></avatar><div class=\"message elevated-bottom\"><a href=\"#\" class=\"name\">{{message.publisherId}}</a><time>{{ message.createdAt | timeLapse }}</time><p class=\"title\">Co-Pilot</p><p>{{ message.body }}</p><ul class=\"attachments\"><li ng-repeat=\"attachment in message.attachments track by $index\"><a href=\"#\">{{ message.attachments.originalUrl }}</a></li></ul><a class=\"download\"><div class=\"icon download smallest\"></div><p>Download all images</p></a></div></li><a id=\"messaging-bottom-{{ vm.threadId }}\"></a></ul><div class=\"respond\"><div class=\"icon warning\"></div><form ng-submit=\"vm.sendMessage()\"><textarea placeholder=\"Send a message&hellip;\" ng-model=\"vm.newMessage\"></textarea><button type=\"submit\" ng-hide=\"vm.sending\" class=\"wider action\">reply</button><button disabled=\"disabled\" ng-show=\"vm.sending\" class=\"wider action\">sending...</button></form></div></main></div>");
$templateCache.put("views/threads.directive.html","<ul><li ng-repeat=\"thread in vm.threads track by $index\"><a ui-sref=\"messaging({ id: thread.id })\" ng-class=\"{unread: thread.unreadCount &gt; 0}\" class=\"unread\"><div class=\"app-name\">{{thread.subject}}</div><div class=\"sender\"><avatar avatar-url=\"{{ thread.publishers[0].avatar }}\"></avatar><div class=\"name\">{{thread.publishers[0]}}</div><time>{{ thread.messages[thread.messages.length -1].createdAt | timeLapse }}</time></div><p class=\"message\">{{ thread.messages[thread.messages.length -1].body }}</p></a></li></ul><div ng-show=\"vm.threads.length == 0\" class=\"none\">None</div>");}]);