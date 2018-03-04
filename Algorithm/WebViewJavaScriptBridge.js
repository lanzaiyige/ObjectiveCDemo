!(function(){
  if(window.WebViewJavascriptBridge) {
    return
  }

  var messagingIframe
  var sendMessageQueue = []
  var receiveMessageQueue = []
  var messageHandlers = {}

  var CUSTOM_PROTOCOL_SCHEME = 'wvjbscheme'
	var QUEUE_HAS_MESSAGE = '__WVJB_QUEUE_MESSAGE__'

  var responseCallbacks = {}
  var uniqueId = 1

  function _createQueueReadyIframe(doc) {
    
  }
})();
