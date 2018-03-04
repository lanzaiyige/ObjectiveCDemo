//
//  MTLJSONAdapter.m
//  Algorithm
//
//  Created by tanzhikang on 2018/2/9.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "MTLJSONAdapter.h"
#import "MTLModel.h"

@interface MTLJSONAdapter()
@property (nonatomic, strong, readonly) Class modelClass;
@property (nonatomic, copy, readonly) NSDictionary *JSONKeyPathsByPropertyKey;

@end

@implementation MTLJSONAdapter

- (id)initWithModelClass:(Class)modelClass {
    self = [super init];
    if(self == nil) return nil;
    
    _modelClass = modelClass;
    
    _JSONKeyPathsByPropertyKey = [modelClass JSONKeyPathsByPropertyKey];
    
    NSSet *propertyKeys = [self.modelClass propertyKeys];
    
    for (NSString *mappedPropertyKey in _JSONKeyPathsByPropertyKey) {
        
    }
    
    return self;
}

@end
