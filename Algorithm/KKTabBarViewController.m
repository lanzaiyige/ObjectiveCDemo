//
//  KKTabBarViewController.m
//  Algorithm
//
//  Created by tanzhikang on 2018/2/5.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "KKTabBarViewController.h"
#import "ViewController.h"

@interface KKTabBarViewController ()

@end

@implementation KKTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *vc = [ViewController new];
    
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:vc];
    navi1.tabBarItem.title = @"haha";
    self.viewControllers = @[navi1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
