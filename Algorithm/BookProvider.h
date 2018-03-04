//
//  BookProvider.h
//  Algorithm
//
//  Created by tanzhikang on 2017/11/22.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookProviderProtocol <NSObject>
- (void)purchaseBookByName:(NSString *)name;
@end

@interface BookProvider : NSObject <BookProviderProtocol>

@end
