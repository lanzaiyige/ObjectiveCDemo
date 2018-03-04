//
//  DealerProxy.h
//  Algorithm
//
//  Created by tanzhikang on 2017/11/22.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookProvider.h"
#import "ClothesProvider.h"

@interface DealerProxy : NSProxy <BookProviderProtocol, ClothesProviderProtocol>
+ (instancetype)dealerProxy;
@end
