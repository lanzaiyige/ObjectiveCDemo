//
//  MTObject.m
//  Algorithm
//
//  Created by tanzhikang on 2018/1/14.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "MTObject.h"
#import <objc/runtime.h>

@implementation MTObject

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if(sel == @selector(test)) {
        class_addMethod([self class], sel, (IMP)testHaha, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

void testHaha(id self, SEL _cmd) {
    NSLog(@"haha");
}

@end
