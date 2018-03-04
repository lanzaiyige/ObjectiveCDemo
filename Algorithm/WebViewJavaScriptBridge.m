//
//  WebViewJavaScriptBridge.m
//  Algorithm
//
//  Created by tanzhikang on 2018/1/31.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "WebViewJavaScriptBridge.h"

static bool logging = false;

typedef NSDictionary WVJBMessage;

@implementation WebViewJavaScriptBridge {
    __weak UIWebView *_webView;
    __weak id _webViewDelegate;
    NSMutableArray *_startupMessageQueue;
    NSMutableDictionary *_responseCallbacks;
    NSMutableDictionary *_messageHandlers;
    long _uniqueId;
    WVJBHandler _messageHandler;
    NSBundle *_resourceBundle;
    NSUInteger _numReqeustLoading;
}

+ (instancetype)bridgeForWebView:(UIWebView*)webView handler:(WVJBHandler)handler {
    return [self bridgeForWebView:webView webViewDelegate:nil handler:handler];
}

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>* )webViewDelegate handler:(WVJBHandler)handler {
    return [self bridgeForWebView:webView webViewDelegate:webViewDelegate handler:handler resourceBundle:nil];
}

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>* )webViewDelegate handler:(WVJBHandler)handler resourceBundle:(NSBundle*)bundle {
    WebViewJavaScriptBridge *bridge = [[WebViewJavaScriptBridge alloc] init];
    [bridge _platformSpecificSetup:webView webViewDelegate:webViewDelegate handler:handler resourceBundle:bundle];
    [bridge reset];
    return bridge;
}

+ (void)enableLogging {
    logging = true;
}

- (void)send:(id)message {
    [self send:message responseCallback:nil];
}

- (void)send:(id)message responseCallback:(WVJBResponseCallback)responseCallback {
    
}

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler {
    
}

- (void)callHandler:(NSString*)handlerName {
    [self callHandler:handlerName data:nil];
}

- (void)callHandler:(NSString*)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [self _sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)reset {
    _startupMessageQueue = [NSMutableArray array];
    _responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

#pragma - Private Method
- (void)_sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName {
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    
    if(data) {
        message[@"data"] = data;
    }
    
    if(responseCallback) {
        NSString* callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        _responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    
    if(handlerName) {
        message[@"handlerName"] = handlerName;
    }
    
    [self _queueMessage:message];
}

- (void)_queueMessage:(WVJBMessage *)message {
    if(_startupMessageQueue) {
        [_startupMessageQueue addObject:message];
    } else {
        [self _dispatchMessage:message];
    }
}

- (void)_dispatchMessage:(WVJBMessage *)message {
    NSString *messageJSON = [self _serializeMessage:message];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", messageJSON];
    if([[NSThread currentThread] isMainThread]) {
        [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
    } else {
        __strong UIWebView *swebView = _webView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [swebView stringByEvaluatingJavaScriptFromString:javascriptCommand];
        });
    }
}

- (void)_flushMessageQueue {
    
}

- (NSString *)_serializeMessage:(WVJBMessage *)message {
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray *)_deserializeMessageJSON:(NSString *)json {
    return [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (void)_platformSpecificSetup:(UIWebView *)webView
                webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
                        handler:(WVJBHandler)messageHandler
                 resourceBundle:(NSBundle*)bundle {
    _messageHandler = messageHandler;
    _webView = webView;
    _webViewDelegate = webViewDelegate;
    _messageHandlers = [NSMutableDictionary dictionary];
    _resourceBundle = bundle;
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(webView != _webView) return;
    
    _numReqeustLoading++;
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if([strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [strongDelegate webViewDidStartLoad:webView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView != _webView) return YES;
    
    NSURL *url = request.URL;
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    
    if([url.scheme isEqualToString:kCustomProtocolScheme]) {
        if([url.host isEqualToString:kQueueHasMessage]) {
            [self _flushMessageQueue];
        } else {
            //todo warning
        }
    } else if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [strongDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return YES;
    }
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
