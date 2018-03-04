//
//  ViewController.h
//  Algorithm
//
//  Created by 谭智康 on 2017/3/26.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BinaryTreeNode;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (strong, nonatomic) BinaryTreeNode *node;

- (nullable NSString *)testNon:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
