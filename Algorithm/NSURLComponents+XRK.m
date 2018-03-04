//
//  NSURLComponents+XRK.m
//  Algorithm
//
//  Created by 谭智康 on 2017/5/26.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import "NSURLComponents+XRK.h"

@implementation NSURLComponents (XRK)

- (void)appendParams:(NSDictionary *)params {
    if (self.path.length == 0) { // 只有host没法拼接，https://super.bxr.im?sds
        self.path = @"/";
    }
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (self.queryItems) {
        [queryItems addObjectsFromArray:self.queryItems];
    }
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *value = [NSString stringWithFormat:@"%@", obj];
        if (value.length > 0) {
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
            NSInteger index = [self itemIndexForName:key inItems:queryItems];
            if (index >= 0) {
                [queryItems replaceObjectAtIndex:index withObject:item];
            } else {
                [queryItems addObject:item];
            }
        }
    }];
    self.queryItems = queryItems;
}

- (NSInteger)itemIndexForName:(NSString *)name inItems:(NSArray<NSURLQueryItem *> *)queryItems{
    __block NSInteger index = -1;
    [queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

@end
