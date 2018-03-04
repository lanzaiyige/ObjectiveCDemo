//
//  ClothesProvider.h
//  Algorithm
//
//  Created by tanzhikang on 2017/11/22.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClothesProviderProtocol <NSObject>
- (void)purchaseClothesWithSize:(NSInteger)size;
@end

@interface ClothesProvider : NSObject <ClothesProviderProtocol>

@end
