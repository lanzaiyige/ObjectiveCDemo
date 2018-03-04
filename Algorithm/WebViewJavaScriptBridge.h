//
//  WebViewJavaScriptBridge.h
//  Algorithm
//
//  Created by tanzhikang on 2018/1/31.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>

#define kCustomProtocolScheme @"wvjbscheme"
#define kQueueHasMessage      @"__WVJB_QUEUE_MESSAGE__"

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

@interface WebViewJavaScriptBridge : NSObject<UIWebViewDelegate>

+ (instancetype)bridgeForWebView:(UIWebView*)webView handler:(WVJBHandler)handler;
+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>* )webViewDelegate handler:(WVJBHandler)handler;
+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>* )webViewDelegate handler:(WVJBHandler)handler resourceBundle:(NSBundle*)bundle;
+ (void)enableLogging;

- (void)send:(id)message;
- (void)send:(id)message responseCallback:(WVJBResponseCallback)responseCallback;
- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)reset;

@end
