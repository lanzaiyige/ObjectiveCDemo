//
//  AppDelegate.m
//  Algorithm
//
//  Created by 谭智康 on 2017/3/26.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "KKTabBarViewController.h"
#import "TestTransformer.h"


@interface BlockObject : NSObject
@property (copy, nonatomic) dispatch_block_t block;
@end

@implementation BlockObject



@end


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)testCPointer {
    int a[5] = {1,2,3,4,5};
    int *ptr = *(&a+1);
    NSLog(@"%p,%i",&a+1,*(ptr-1));
}

- (void)testBlock {
    static int outA = 8;
    
    int(^myPtr)(int) = ^(int a) {
        return  outA + a;
    };
    outA = 10;
    //去与 block 在同一个作用域中值
    int result = myPtr(3);
    __block int outC = 8;
    int(^myPtrC)(int) = ^(int c) {
        outC = 10;
        return  outC + c;
    };
    
    NSLog(@"block 内部 变 outC的值为10后 会是13嘛 %d",myPtrC(3));
}

- (NSString *)hexFromInt:(NSInteger)integer {
    return [NSString stringWithFormat:@"%i",integer];
}

- (void)testValueTransformer {
    NSValueTransformer *trans = [TestTransformer new];
    NSString *dateStr = [trans transformedValue:[NSDate date]];
    NSLog(@"%@",dateStr);
    
    NSDate *date = [trans reverseTransformedValue:dateStr];
    NSLog(@"%@",date);
}

- (void)testGlobalBlock {
     int temp = 10;
    NSLog(@"%@", [^(){
        NSLog(@"%i", temp);
    } copy]);
}

- (void)testBlockVariable {
    int temp = 10;
    __block int blockTemp = 10;
    void (^block)() = ^() {
        NSLog(@"temp:%i",temp);
        NSLog(@"blockTemp:%i",blockTemp);
    };
    
    temp += 5;
    blockTemp += 5;
    block();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self testGlobalBlock];
//    [self testBlockVariable];
    
    BlockObject *object = [BlockObject new];
    object.block = ^(){
//        NSLog(@"%@",object);
    };
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    KKTabBarViewController *tabbar = [KKTabBarViewController new];
    
    ViewController *mtbvc = [ViewController new];
    self.window.rootViewController = mtbvc;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
