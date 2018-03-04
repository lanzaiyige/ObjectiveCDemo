//
//  MTLModel.m
//  Algorithm
//
//  Created by tanzhikang on 2018/2/9.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "MTLModel.h"
#import <objc/runtime.h>

static void *MTLModelCachedPropertyKeysKey = &MTLModelCachedPropertyKeysKey;

@implementation MTLModel

+ (NSSet *)propertyKeys {
    NSSet *cachedKeys = objc_getAssociatedObject(self, MTLModelCachedPropertyKeysKey);
    if(cachedKeys) return cachedKeys;
    
    NSMutableSet *keys = [NSMutableSet set];
    
    [self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
        NSString *key = @(property_getName(property));
        
        //todo addKey to set
    }];
    
    objc_setAssociatedObject(self, MTLModelCachedPropertyKeysKey, keys, OBJC_ASSOCIATION_COPY);
    
    return keys;
}

+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block {
    
}

@end
