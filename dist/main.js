(function() {
  'use strict';
  var dependencies;

  dependencies = ['ui.router', 'ngResource', 'app.constants', 'duScroll', 'appirio-tech-ng-ui-components', 'ap-file-upload', 'appirio-tech-ng-api-services'];

  angular.module('appirio-tech-ng-messaging', dependencies);

}).call(this);

(function() {
  'use strict';
  var MessagingController;

  MessagingController = function($scope, $document, $filter, API_URL, MessagesAPIService, ThreadsAPIService, InboxesAPIService, MessageUpdateAPIService) {
    var activate, activateImageSlideViewer, configureUploader, findFirstUnreadMessageIndex, generateProfileUrl, getThread, isMessageValid, markMessageRead, onFileChange, orderMessagesByCreationDate, sendMessage, setFileUrls, vm;
    vm = this;
    vm.currentUser = null;
    vm.activeThread = null;
    vm.sending = false;
    vm.loadingThreads = false;
    vm.loadingMessages = false;
    vm.showImageSlideViewer = false;
    vm.workId = $scope.workId;
    vm.threadId = $scope.threadId;
    vm.subscriberId = $scope.subscriberId;
    vm.uploaderUploading = null;
    vm.uploaderHasErrors = null;
    vm.uploaderHasFiles = null;
    generateProfileUrl = function(handle) {
      return "https://www.topcoder.com/members/" + handle;
    };
    orderMessagesByCreationDate = function(messages) {
      var orderedMessages;
      orderedMessages = messages != null ? messages.sort(function(previous, next) {
        return new Date(previous.createdAt) - new Date(next.createdAt);
      }) : void 0;
      return orderedMessages;
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
      vm.newAttachments = [];
      $scope.$watch('subscriberId', function() {
        return getThread();
      });
      vm.sendMessage = sendMessage;
      vm.generateProfileUrl = generateProfileUrl;
      vm.uploaderConfig = configureUploader(vm.threadId, 'attachment');
      vm.activateImageSlideViewer = activateImageSlideViewer;
      vm.onFileChange = onFileChange;
      $scope.$watch('vm.uploaderUploading', function(newValue) {
        if (newValue === true) {
          return vm.disableSend = true;
        } else {
          return vm.disableSend = false;
        }
      });
      return vm;
    };
    configureUploader = function(threadId, assetType) {
      var category, domain, uploaderConfig;
      domain = API_URL;
      category = 'message';
      uploaderConfig = {
        name: assetType + "-uploader-" + threadId + "-" + (Date.now()),
        allowMultiple: true,
        allowCaptions: false,
        onUploadSuccess: function(data) {
          return vm.newAttachments.push({
            ownerId: $scope.subscriberId,
            id: data.id,
            fileName: data.name,
            filePath: data.path,
            fileType: data.type,
            fileSize: data.size
          });
        },
        presign: {
          url: domain + '/v3/attachments/uploadurl',
          params: {
            id: threadId,
            assetType: assetType,
            category: category
          }
        },
        removeRecord: {
          url: domain + '/v3/attachments/:fileId',
          params: {
            filter: 'category=' + category
          }
        }
      };
      return uploaderConfig;
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
          vm.firstUnreadMessageIndex = findFirstUnreadMessageIndex(vm.thread.messages);
          if (vm.thread.unreadCount > 0) {
            lastMessage = vm.thread.messages[vm.thread.messages.length - 1];
            markMessageRead(lastMessage);
          }
          if (vm.firstUnreadMessageIndex > 0) {
            return angular.element(document).ready(function() {
              var scrollElement;
              vm.thread.messages[vm.firstUnreadMessageIndex - 1].showNewMessage = true;
              scrollElement = angular.element(document.getElementById(vm.firstUnreadMessageIndex));
              return $document.scrollToElement(scrollElement);
            });
          } else {
            return $scope.showLast = 'scroll';
          }
        });
        resource.$promise["catch"](function() {});
        return resource.$promise["finally"](function() {
          return vm.loadingThreads = false;
        });
      }
    };
    findFirstUnreadMessageIndex = function(messages) {
      var unreadMessages;
      unreadMessages = messages.filter(function(message) {
        return !message.read;
      });
      return messages.indexOf(unreadMessages[0]);
    };
    isMessageValid = function(message, attachments) {
      var valid;
      valid = true;
      if (attachments.length > 0) {
        if (vm.uploaderUploading) {
          valid = false;
          vm.disableSend = true;
        }
      } else {
        if (!vm.newMessage.length || !vm.thread) {
          valid = false;
          vm.disableSend = true;
        }
      }
      return valid;
    };
    sendMessage = function() {
      var message, resource;
      if (isMessageValid(vm.newMessage, vm.newAttachments)) {
        message = {
          param: {
            publisherId: $scope.subscriberId,
            threadId: vm.threadId,
            body: vm.newMessage,
            attachments: vm.newAttachments
          }
        };
        vm.disableSend = true;
        resource = MessagesAPIService.post(message);
        resource.$promise.then(function(response) {
          vm.uploaderConfig = configureUploader(vm.threadId, 'attachment');
          vm.newMessage = '';
          vm.newAttachments = [];
          $scope.showLast = 'scroll';
          return getThread();
        });
        resource.$promise["catch"](function(response) {});
        return resource.$promise["finally"](function() {
          return vm.disableSend = false;
        });
      }
    };
    setFileUrls = function(files) {
      var urlFiles;
      urlFiles = files.map(function(file) {
        file.url = file.thumbnailUrl;
        return file;
      });
      return urlFiles;
    };
    activateImageSlideViewer = function(file, files, handle, avatar, date) {
      vm.showImageSlideViewer = true;
      file.url = file.thumbnailUrl;
      vm.currentImage = file;
      vm.currentImages = setFileUrls(files);
      vm.currentHandle = handle;
      vm.currentAvatar = avatar;
      return vm.currentTitle = $filter('timeLapse')(date);
    };
    onFileChange = function(file) {
      return vm.currentImage = file;
    };
    return activate();
  };

  MessagingController.$inject = ['$scope', '$document', '$filter', 'API_URL', 'MessagesAPIService', 'ThreadsAPIService', 'InboxesAPIService', 'MessageUpdateAPIService'];

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

angular.module("appirio-tech-ng-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.directive.html","<ul id=messaging-message-list class=messages><li ng-repeat-start=\"message in vm.thread.messages track by $index\" id={{$index}} class=\"flex center middle\"><div class=user-name><div href={{vm.generateProfileUrl(message.publisher.handle)}} target=_blank class=name>{{message.publisher.handle}}</div><time>{{ message.createdAt | timeLapse }}</time></div><a href={{vm.generateProfileUrl(message.publisher.handle)}} target=_blank class=avatar><avatar avatar-url=\"{{ message.publisher.avatar }}\"></avatar></a><div class=\"message elevated-bottom flex-grow\"><ul ng-if=\"message.attachments.length &gt; 0\" class=\"attachments flex\"><li ng-repeat=\"attachment in message.attachments track by $index\"><button ng-click=\"vm.activateImageSlideViewer(attachment, message.attachments, message.publisher.handle, message.publisher.avatar, message.createdAt)\" class=clean><img ng-src={{attachment.thumbnailUrl}}></button></li></ul><p ng-if=\"message.publisher.role != null\" class=title>{{message.publisher.role}}</p><p>{{ message.body }}</p></div></li><li ng-repeat-end=ng-repeat-end ng-if=message.showNewMessage class=new-messages><p>new messages</p><hr></li><a id=\"messaging-bottom-{{ vm.threadId }}\"></a></ul><div class=respond><ap-uploader config=vm.uploaderConfig uploading=vm.uploaderUploading has-errors=vm.uploaderHasErrors has-files=vm.uploaderHasFiles></ap-uploader><form ng-submit=vm.sendMessage() class=\"flex middle center\"><textarea placeholder=\"Send a message...\" ng-model=vm.newMessage ng-class=\"{resizeDisabled: vm.showImageSlideViewer}\"></textarea><button type=submit ng-hide=vm.disableSend class=action>reply</button><button disabled ng-show=vm.disableSend class=action>reply</button></form></div><attachment-viewer ng-if=vm.showImageSlideViewer><modal show=vm.showImageSlideViewer background-click-close=background-click-close><image-viewer-header title={{vm.currentTitle}} avatar={{vm.currentAvatar}} handle={{vm.currentHandle}} download-url=vm.currentImage.thumbnailUrl download-allowed=download-allowed></image-viewer-header><image-slide-viewer on-file-change=vm.onFileChange(file) files=vm.currentImages starting-file=vm.currentImage></image-slide-viewer></modal></attachment-viewer>");}]);