//
//  DealerProxy.m
//  Algorithm
//
//  Created by tanzhikang on 2017/11/22.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import "DealerProxy.h"
#import <objc/runtime.h>

@interface DealerProxy() {
    BookProvider *_bookProvider;
    ClothesProvider *_clothesProvider;
    NSMutableDictionary *_methodMap;
}
@end

@implementation DealerProxy

+ (instancetype)dealerProxy {
    return [[self.class alloc] init];
}

- (instancetype)init {
    _methodMap = [NSMutableDictionary dictionary];
    _bookProvider = [BookProvider new];
    _clothesProvider = [ClothesProvider new];
    
    return self;
}

- (void)_registerMethodsWithTarget:(id)target {
    unsigned int methodsCount;
    
    Method *methods = class_copyMethodList(self.class, &methodsCount);
    
    for (int i = 0; i < methodsCount; i++) {
        Method temp_method = methods[i];
        SEL temp_sel = method_getName(temp_method);
        const char *selName = sel_getName(temp_sel);
        [_methodMap setObject:target forKey:[NSString stringWithUTF8String:selName]];
    }
    free(methods);
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    NSString *methodName = NSStringFromSelector(sel);
    id target = _methodMap[methodName];
    if(target && [target respondsToSelector:sel]) {
        [invocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSString *methodName = NSStringFromSelector(sel);
    id target = _methodMap[methodName];
    if(target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

@end
