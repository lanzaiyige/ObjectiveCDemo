//
//  TestViewController.m
//  Algorithm
//
//  Created by tanzhikang on 2018/2/10.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "TestViewController.h"

@interface TestCell : UITableViewCell
@property (copy, nonatomic) dispatch_block_t block;
@property (assign, nonatomic) NSInteger num;
@end

@implementation TestCell

- (void)setNum:(NSInteger)num {
    _num = num;
    self.textLabel.text = [NSString stringWithFormat:@"%ld",num];
    if(num == 0) {
        if(self.block) {
            self.block();
        }
    }
}

@end

@interface TestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 300, 300) style:UITableViewStylePlain];
    [self.tableView registerClass:[TestCell class] forCellReuseIdentifier:@"test"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    cell.block = ^(){
        [self log];
    };
    cell.num = arc4random() % 5;
    return cell;
}

- (void)log {
    NSLog(@"%@",self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
