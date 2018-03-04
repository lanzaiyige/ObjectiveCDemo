//
//  KKAutoDictionary.m
//  Algorithm
//
//  Created by 谭智康 on 2017/7/1.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import "KKAutoDictionary.h"
#import <objc/runtime.h>

@interface KKAutoDictionary()<NSCopying>

@property (nonatomic, strong) NSMutableDictionary *backingStore;

@end

@implementation KKAutoDictionary

@dynamic string, number, date, object;

- (instancetype)init {
    self = [super init];
    if(self) {
        _backingStore = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return nil;
}

void autoDictionarySetter(id self, SEL _cmd, id value) {
//    KKAutoDictionary *typeSelf = (KKAutoDictionary *)self;
//    NSMutableDictionary *backingStore = typeSelf.backingStore;
    
    
}

id autoDictionaryGetter(id self, SEL _cmd) {
    KKAutoDictionary *typeSelf = (KKAutoDictionary *)self;
    NSMutableDictionary *backingStore = typeSelf.backingStore;
    
    NSString *key = NSStringFromSelector(_cmd);
    return [backingStore objectForKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if([selectorString hasPrefix:@"set"]) {
//        class_addMethod(self, sel, <#IMP imp#>, <#const char *types#>)
    } else {
        
    }
    
    return YES;
}

@end
