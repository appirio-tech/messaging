# Messaging
[![Build Status](https://travis-ci.org/appirio-tech/ng-messaging.svg?branch=master)](https://travis-ci.org/appirio-tech/ng-messaging)
[![Coverage Status](https://coveralls.io/repos/appirio-tech/messaging/badge.svg?branch=master&t=qP5jFO)](https://coveralls.io/r/appirio-tech/messaging?branch=master)

## Examples
```jade
messaging.widget(thread-id="123" subscriber-id="Batman")

messaging(thread-id="123" subscriber-id="Batman")

threads(subscriber-id="123")
```

## Development

### API
http://docs.messaging14.apiary.io/#

### Designs
https://drive.google.com/a/appirio.com/folderview?id=0B6NlMQSXkImbfkNhcWFTYWViMEpZRkJ2d0xVbEI5ZTdHQzlIaFBSc0VsN2lCMnNwN1VGVW8&usp=sharing_eid


### Gulp Tasks
```
alias gserve='nvm use; gulp clean; gulp serve'
alias gtest='nvm use; gulp test'
alias gtestserve='nvm use; gulp test-serve'
alias gbuild='nvm use; gulp clean; gulp preprocessors; gulp useref; gulp copy-files;'
```