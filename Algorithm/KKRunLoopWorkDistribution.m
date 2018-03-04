//
//  KKRunLoopWorkDistribution.m
//  Algorithm
//
//  Created by tanzhikang on 2018/2/12.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "KKRunLoopWorkDistribution.h"
#import <objc/runtime.h>

@implementation KKRunLoopWorkDistribution

static void _registerObserver(CFOptionFlags activities, CFRunLoopObserverRef observer, CFIndex order, CFStringRef mode, void *info, CFRunLoopObserverCallBack callback) {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        info,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    observer = CFRunLoopObserverCreate(NULL, activities, YES, order, callback, &context);
    CFRunLoopAddObserver(runloop, observer, mode);
    CFRelease(observer);
}

@end
