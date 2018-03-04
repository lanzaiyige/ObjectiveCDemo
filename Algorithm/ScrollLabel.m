//
//  ScrollLabel.m
//  Algorithm
//
//  Created by tanzhikang on 2018/1/23.
//  Copyright © 2018年 tanzk. All rights reserved.
//

#import "ScrollLabel.h"

@interface ScrollLabel()

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UILabel *label1;

@property (strong, nonatomic) UILabel *label2;

@property (assign, nonatomic) NSInteger currentIndex;
@end

@implementation ScrollLabel

- (void)dealloc {
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.clipsToBounds = YES;
        
        _currentIndex = 0;
        _label1 = [[UILabel alloc] initWithFrame:self.bounds];
        _label1.userInteractionEnabled = YES;
        _label1.backgroundColor = [UIColor yellowColor];
        
        [_label1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(log)]];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _label2.backgroundColor = [UIColor greenColor];
        _label2.userInteractionEnabled = YES;
        [_label2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(log)]];
        
        [self addSubview:_label1];
        [self addSubview:_label2];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            //todo 自动轮播
            [self changeTitle];
        }];
    }
    return self;
}

- (void)log {
    NSLog(@"haha");
}

- (void)changeTitle {
    [UIView animateWithDuration:1 animations:^{
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat oneY = 0;
        CGFloat towY = 0;
        
        if(_label1.frame.origin.y > 0) {
            oneY = 0;
        } else {
            oneY = -height;
        }
        
        if(_label2.frame.origin.y > 0) {
            towY = 0;
        } else {
            towY = -height;
        }
        
        _label1.frame = CGRectMake(0, oneY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _label2.frame = CGRectMake(0, towY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        
    } completion:^(BOOL finished) {
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat oneY = 0;
        CGFloat towY = 0;
        
        
        _currentIndex += 1;
        
        
        NSLog(@"index:%i",_currentIndex);
        
        if(_label1.frame.origin.y < 0) {
            oneY = height;
            _label1.text = [self.titles objectAtIndex:_currentIndex+1];
        }
        
        if(_label2.frame.origin.y < 0) {
            towY = height;
            _label2.text = [self.titles objectAtIndex:_currentIndex+1 < self.titles.count ? : 0];
        }
        
        
        if(_currentIndex == self.titles.count - 1) {
            _currentIndex = 0;
        }
        
        _label1.frame = CGRectMake(0, oneY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _label2.frame = CGRectMake(0, towY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }];
}

- (void)setTitles:(NSArray *)titles {
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in titles) {
        if(obj && [obj isKindOfClass:[NSString class]]) {
            [array addObject:obj];
        }
    }
    
    _titles = array;
    
    _label1.text = [_titles objectAtIndex:_currentIndex];
    _label2.text = [_titles objectAtIndex:_currentIndex + 1];
}

@end
