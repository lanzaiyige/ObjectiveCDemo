//
//  TestTransformer.m
//  Algorithm
//
//  Created by tanzhikang on 2018/2/9.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "TestTransformer.h"

@implementation TestTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSString class];
}

-(NSDateFormatter *)dateFormatter{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return formatter;
}

- (id)transformedValue:(id)value {
    
    return [[self dateFormatter] stringFromDate:value];
}

- (id)reverseTransformedValue:(id)value {
    return [[self dateFormatter] dateFromString:value];
}

@end
