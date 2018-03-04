//
//  KKMemoryCache.h
//  Algorithm
//
//  Created by tanzhikang on 2018/1/23.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKMemoryCache : NSObject

@property (nullable, copy) NSString *name;

@property (readonly) NSUInteger totalCount;

@property (readonly) NSUInteger totalCost;

@property NSUInteger countLimit;

@property NSUInteger costLimit;

@property NSTimeInterval ageLimit;

@property NSTimeInterval autoTrimInterval;
@end
