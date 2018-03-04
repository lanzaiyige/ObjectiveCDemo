//
//  ViewController.m
//  Algorithm
//
//  Created by 谭智康 on 2017/3/26.
//  Copyright © 2017年 tanzk. All rights reserved.
//

#import "ViewController.h"
#import "BinaryTreeNode.h"
#import "NSURLComponents+XRK.h"
#import <objc/runtime.h>
#import <pthread.h>
#import <objc/message.h>
#import <Security/Security.h>
#import <Security/SecKey.h>
#import "AppDelegate.h"
#import <CoreText/CoreText.h>
#import "MTObject.h"
#import <assert.h>
#import <pthread.h>
#import "ScrollLabel.h"
#import "CoreTextView.h"
#import "TestViewController.h"

static void *customerKey = &customerKey;

void printHello() {
    printf("hello world");
}

void printGoodBye() {
    printf("Good Bye");
}

void doSomeThing(int type) {
    void (*func)();
    
    if(type == 0) {
        func = printHello;
    } else {
        func = printGoodBye;
    }
    
    func();
    return;
}

@interface Person : NSObject
@property (nonatomic, copy) NSString *cpName;
@property (nonatomic, strong) NSString *strongName;
@end

@implementation Person

@end

@interface TestCopy : NSObject<NSCopying>

@property (strong, nonatomic) NSString *str;

@end

@implementation TestCopy

- (instancetype)init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if(self) {
        _str = name;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TestCopy *tp = [[[self class] allocWithZone:zone] initWithName:self.str];
    
    return tp;
}

@end

@interface TestView : UIView
@property (nonatomic, copy) NSString *cStr;
@property (nonatomic, strong) NSString *sStr;

@end

@implementation TestView

- (instancetype)init {
    self = [super init];
    if(self) {
        _cStr = @"xixi";
    }
    return self;
}

- (void)p_testPrivate {
    NSLog(@"TestView");
}

- (void)setCustomerProperty:(NSString *)str {
    
    objc_setAssociatedObject(self, customerKey, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)customerProperty {
    return objc_getAssociatedObject(self, customerKey);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (NSUInteger)hash {
    NSUInteger cStrhash = [_cStr hash];
    NSUInteger sStrhash = [_sStr hash];
    
    return cStrhash ^ sStrhash;
}

@end

@interface ViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) dispatch_block_t testBlock;
@property (strong, nonatomic) NSString *testStr;
@property (strong, nonatomic) NSThread *thread;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) CALayer *blueLayer;
@end

@implementation ViewController

- (void)testDosomething {
    
}

void *operate(void *param) {
    pthread_setname_np("my_thread");
    char thread_name[10];
    pthread_getname_np(pthread_self(), thread_name, 10);
    printf("an operation running in %s",thread_name);
    pthread_exit((void *)0);
}

const void* CustomKeyCallBack(CFAllocatorRef allocator, const void* value) {
    return CFRetain(value);
}

void CustomReleaseCallBack(CFAllocatorRef allocator, const void* value) {
    CFRelease(value);
}

CFDictionaryKeyCallBacks keyCallBacks = {
    0,
    CustomKeyCallBack,
    CustomReleaseCallBack,
    NULL,
    CFEqual,
    CFHash
};

CFDictionaryValueCallBacks valueCallBack = {
    0,
    CustomKeyCallBack,
    CustomReleaseCallBack,
    NULL,
    CFEqual
};

- (void)testKeyChain {
    NSMutableDictionary *keyChainDict = [NSMutableDictionary dictionary];
    [keyChainDict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//    [keyChainDict setObject:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:kSecAttrDescription];
    [keyChainDict setObject:@"UUID" forKey:(id)kSecAttrGeneric];
    
}


- (NSString *)stringWithLabelFrame:(CGRect)rect
                              font:(UIFont *)font
                              text:(NSString *)text
                             lines:(NSInteger *)lineCount {
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    *lineCount = lines.count;
    
    if(lines.count > 3) {
        __block NSString *resultStr = @"";
        
        [lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx == 3) {
                *stop = YES;
            } else {
                CTLineRef lineRef = (__bridge CTLineRef )obj;
                
                CFRange lineRange = CTLineGetStringRange(lineRef);
                NSRange range = NSMakeRange(lineRange.location, lineRange.length);
                NSString *lineString = [text substringWithRange:range];
                NSLog(@"%@",lineString);
                if(idx == 2) {
                    NSInteger sum = 0;
                    for(int i = 0; i < [lineString length]; i++){
                        unichar strChar = [lineString characterAtIndex:i];
                        if(strChar < 256)
                            sum += 1;
                        else
                            sum += 2;
                        
                        if(sum >= 24) {
                            lineString = [lineString substringToIndex:i];
                        }
                    }
                    
                    lineString = [[lineString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingString:@"...查看更多"];
                    resultStr = [resultStr stringByAppendingString:lineString];
                } else {
                    resultStr = [resultStr stringByAppendingString:lineString];
                }
            }
        }];
        
        return resultStr;
    }
    return text;
}

- (void)testNil {
    NSDictionary *dict = @{@"type":@(0), @"haha":@"123"};
    
    id test = dict[@"type"];
    if(test && test != 0) {
        NSLog(@"123");
    } else {
        NSLog(@"456");
    }
    
    NSString *a1;
    NSString *a2 = @"";
    if([a1 isEqualToString:a2]) {
        NSLog(@"yes");
    } else {
        NSLog(@"no");
    }
}

- (void)testCopyAndStrongNString {
    
    NSURLComponents *component = [NSURLComponents componentsWithString:@"123"];
    [component appendParams:@{@"test" : @"1"}];
    
//    Person *p1 = [Person new];
    //    NSMutableString *mstr = [NSMutableString stringWithFormat:@"kangkang"];
    NSString *mstr = @"abc";
    //    p1.strongName = mstr;
    //    p1.cpName = mstr;
    id p2 = [mstr copy];
    id p3 = [mstr mutableCopy];
    
    NSLog(@"0:%p",mstr);
    NSLog(@"1:%p",p2);
    NSLog(@"2:%p",p3);
}

- (void)testRegular {
    NSString *pattern = @"[1-9]\\d*|0";
    NSString *sourceStr = @"abc123def456ghi";
    
    NSRegularExpression *express = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRange range = [express rangeOfFirstMatchInString:sourceStr options:NSMatchingReportCompletion range:NSMakeRange(0, sourceStr.length)];
    if(range.location > 0) {
//        NSLog(@"%i",range.location);
//        NSLog(@"%i",range.length);
    }
}

- (void)loadView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    ((UIScrollView *)self.view).contentSize = CGSizeMake(width, 1000);
}

- (NSString *)URLEncodedString:(NSString *)str
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = str;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)unencodedString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}


-(NSURLComponents *)decodeString:(NSString*)encodedString {
    NSURLComponents *component = [NSURLComponents componentsWithString:encodedString];
    NSMutableArray *queryItems = [NSMutableArray arrayWithArray:component.queryItems];
    [component.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if([item.name isEqualToString:@"redirect_uri"]) {
            NSString *str = [self URLEncodedString:item.value];
            NSString *st1 = [self URLEncodedString:str];
            
            NSURLQueryItem *resultItem = [[NSURLQueryItem alloc] initWithName:@"redirect_uri" value:item.value];
            [queryItems replaceObjectAtIndex:idx withObject:resultItem];
        }
    }];
    component.queryItems = queryItems;
    
//    NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
//    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encodedString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return component;
}

- (void)testComponent {
    
    NSString *str = @"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx04327fc2be773b29&redirect_uri=http%3A%2F%2Fim.xiangrikui.com%2Freader_web%2Fshared_article%2Fapp%2Farticles%2Farticles%2F5a5469c5fca44dbd8eb17682.html%3Fsso_id%3D3308331%26username%3Dh6yusdoe%26shared_record_id%3D5a5705bba419f387baf30e36%26anonymous%3D0%26channel_id%3D1%26xrk_is_share%3D0&response_type=code&scope=snsapi_userinfo&state=2753c926-c551-498a-ad92-f98892dbb5a3#wechat_redirect";
    
    NSString *st1 = @"http://im.xiangrikui.com/reader_web/shared_article/app/articles/articles/545b402a6e6f644551d10000.html?sso_id=3257745&username=u3257745&shared_record_id=5a406e1817cbc0116c7b1eca&anonymous=0&channel_id=1";
    
    NSURLComponents *result = [self decodeString:str];
    NSString *result1 = [self URLEncodedString:st1];
    NSLog(@"haha");
}

- (void)testRegex {
    NSString *ip = @"var returnCitySN = {\"cip\": \"117.136.79.54\", \"cid\": \"CN\", \"cname\": \"CHINA\"}";
    
    NSRange range = [ip rangeOfString:@"(?<=\\{).*?(?=\\})" options:NSRegularExpressionSearch range:NSMakeRange(0, ip.length)];
    
    NSString *str = [ip substringWithRange:range];
    NSLog(@"%@",str);
    
    if([ip rangeOfString:@"{"].location != NSNotFound &&
       [ip rangeOfString:@"}"].location != NSNotFound) {
        NSUInteger begin = [ip rangeOfString:@"{"].location - 1;
        NSUInteger end = [ip rangeOfString:@"}"].location + 1;
        NSString *json = [[ip substringToIndex:end] substringFromIndex:begin];
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if(dict) {
            ip = dict[@"cip"];
        }
    }
}

- (NSThread *)thread {
    if(!_thread) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(onThread) object:nil];
        _thread.name = @"customThread";
    }
    return _thread;
}

- (void)onThread {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop 进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop 要处理timers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop 要处理sources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop 准备沉睡");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop 准备唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop 退出了");
                break;
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)printLog {
    NSLog(@"----");
}

- (void)testRunLoop {
    [self.thread performSelector:@selector(printLog) onThread:self.thread withObject:nil waitUntilDone:NO];
}

void * PosixThreadMainRoutine(void* data) {
    return NULL;
}

void LaunchThread() {
    pthread_attr_t attr;
    pthread_t posixThreadID;
    int returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    int threadError = pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, NULL);
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    if(threadError != 0) {
        
    }
}

- (void)reload {
    [self.webview reload];
}

- (void)loadRequest {
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/index1.html"]]];
}

- (void)setupWebView {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    id obj = @"haha";
    NSDictionary *param = @{@"name":obj};
    [dict setDictionary:param];
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 300, 200)];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/index1.html"]]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"xixi" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 20, 30, 40);
    [button addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"xixi" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button1.frame = CGRectMake(100, 20, 30, 40);
    [button1 addTarget:self action:@selector(loadRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)testAttribute {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 300)];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"123456789"];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 9)];
    [attribute addAttribute:NSLinkAttributeName value:@"https://www.baidu.com" range:NSMakeRange(0, 3)];
    label.attributedText = attribute;
    [self.view addSubview:label];
}


- (NSString *)subStringByByteWithIndex:(NSInteger)index str:(NSString *)str {
    NSInteger sum = 0;
    NSString *subStr = [[NSString alloc] init];
    
    if(str.length > index) {
        for(int i = 0; i < index; i++){
            unichar strChar = [str characterAtIndex:str.length - index];
            if(strChar < 256){
                sum += 1;
            }
            else {
                sum += 2;
            }
            if (sum <= index) {
                subStr = [str substringToIndex:str.length - i - 1];
            }
        }
    }
    
    subStr = [subStr stringByAppendingString:@"...查看更多"];
    
    return subStr;
}

- (void)log {
    TestViewController *vc = [TestViewController new];
    vc.title = @"xixi";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testCoreTextView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CoreTextView *view = [[CoreTextView alloc] initWithFrame:(CGRect){0,20,CGSizeMake(width, 100)}];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(log)];
    
    [view addGestureRecognizer:tapGesture];
    [self.view addSubview:view];
}

- (void)testLayer {
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    self.blueLayer = blueLayer;
    [self.view.layer addSublayer:blueLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.4];
    self.blueLayer.position = touchPoint;
    [CATransaction commit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testLayer];
    
    
//
//    ScrollLabel *label = [[ScrollLabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
//    label.titles = @[@"小红",@"小明",@"小康康"];
//    [self.view addSubview:label];
    
//    NSString *str = @"com.xiangrikui.imbxr://learn/askfree";
//    NSURL *url = [NSURL URLWithString:str];
//    NSLog(@"haha");
    
    
//    [self testRunLoop];
//    MTObject *obj = [MTObject new];
//    [obj performSelector:@selector(test)];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 400)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    
    //    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 500)];
    //
    //    NSMutableArray *marray = [NSMutableArray arrayWithObjects:@"xixi",@"haha", nil];
    //    NSMutableArray *array = [marray copy];
    //    [array addObject:@"hehe"];
    
    //    [self test];
    
    //    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:nil];
    //    NSLog(@"---%@",returnArray);
    
    //    NSString *link = @"/Users/tanzhikang/Library/Developer/CoreSimulator/Devices/CB4F3299-CBE3-4AA5-99BC-ED24C1FAD7A1/data/Containers";
    ////    NSLog(@"%lu",(unsigned long)link.length);
    //
    //    NSString *imageLink = @"https://www.baidu.com?outer_channel=123";
    //    NSURLComponents *components = [NSURLComponents componentsWithString:imageLink];
    //    if(components) {
    //
    //        [components appendParams:@{@"outer_channel":@"1000000004"}];
    //
    //        imageLink = components.URL.absoluteString;
    //    }
    //
    //    NSLog(@"%@",imageLink);
    
    //    NSLog(@"%@://%@%@",url.scheme,url.host,url.path);
    
    /*
     CFMutableDictionaryRef cfDict = CFDictionaryCreateMutable(NULL, 10, &keyCallBacks, &valueCallBack);
     NSMutableDictionary *mutableDict = (__bridge_transfer NSMutableDictionary *)cfDict;
     
     
     [[NSNotificationCenter defaultCenter] addObserverForName:@"" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
     
     }];
     
     dispatch_apply(10, dispatch_get_main_queue(), ^(size_t t) {
     
     });
     
     
     NSArray *array = [NSArray array];
     for (id object in [array reverseObjectEnumerator]) {
     
     }
     
     CFArrayRef cfArray = (__bridge CFArrayRef)array;
     CFArrayGetCount(cfArray);
     
     
     dispatch_group_t group = dispatch_group_create();
     for (id objc in @[@"1",@"2"]) {
     dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //todo
     });
     }
     dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
     //todo
     
     dispatch_group_notify(group, dispatch_get_main_queue(), ^{
     //todo
     });
     */
    
    //    TestCopy *tp = [[TestCopy alloc] initWithName:@"haha"];
    //    NSLog(@"%@",tp.str);
    //    tp.str = @"xixi";
    //    TestCopy *tp1 = [tp copy];
    //    NSLog(@"%@",tp1.str);
    
    //    TestView *view = [[TestView alloc] init];
    //    NSMutableString *mutableStr = [NSMutableString stringWithString:@"xixi"];
    //    view.cStr = mutableStr;
    //    view.sStr = mutableStr;
    //    [mutableStr appendString:@"haha"];
    //
    //    NSLog(@"%@",view.cStr);
    //    NSLog(@"%@",view.sStr);
    //    NSMutableArray *firstArray = [NSMutableArray array];
    //    NSMutableArray *secondArray = [NSMutableArray array];
    //    [firstArray addObject:secondArray];
    //    [secondArray addObject:firstArray];
    
    //    TestView *view = [[TestView alloc] initWithFrame:CGRectZero];
    
    //    BinaryTreeNode *node = [BinaryTreeNode createTreeWithValues:@[@(1),@(2),@(3),@(4),@(5)]];
    
}

- (void)baseTest {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *str = @"如果是理财高手，三年交150000，六十岁领取的话，不如选一个5%以上收益的自己理财，用复利计划器自己去算就知道终值哪个高了，买大额的基本用于传承和避税避债，穷人就没必要凑合了，如果是理财高手，三年交150000，六十岁领取的话，不如选一个5%以上收益的自己理财，用复利计划器自己去算就知道终值哪个高了，买大额的基本用于传承和避税避债，穷人就没必要凑合了，如果是理财高手，三年交150000，六十岁领取的话，不如选一个5%以上收益的自己理财，用复利计划器自己去算就知道终值哪个高了，买大额的基本用于传承和避税避债，穷人就没必要凑合了";
    
    NSInteger lineCount = 0;
    
    CGFloat kUIScreenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineHeightMultiple = 1;
    [attribute setAttributes:@{NSParagraphStyleAttributeName : style ,NSFontAttributeName : font} range:NSMakeRange(0, str.length)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, kUIScreenWidth - 56, 200)];
    label.backgroundColor = [UIColor greenColor];
    label.attributedText = attribute;
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

- (void)testcopyFile {
        NSString *resourcePath = @"/Users/tanzhikang/personal/yuedu-ios/YueDu/YueDu/Resources";
    
        NSString *publicImgSetPath = [resourcePath stringByAppendingPathComponent:@"public.xcassets"];
    
        NSArray *array = @[
                           @"placeholderImage.xcassets",
                           @"appIcon.xcassets",
                           @"guide.xcassets",
                           @"public.xcassets"
                           ];
    
        NSError *error;
        NSArray<NSString *> *subImgSets = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
        [subImgSets enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![array containsObject:obj]) {
                NSString *currentImgSetPath = [resourcePath stringByAppendingPathComponent:obj];
    
                BOOL isDirectory;
                [[NSFileManager defaultManager] fileExistsAtPath:currentImgSetPath isDirectory:&isDirectory];
                if(isDirectory) {
                    NSArray *currentImgSetSub = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentImgSetPath error:nil];
                    [currentImgSetSub enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(![obj isEqualToString:@"Contents.json"]) {
                            NSString *lastPath = [currentImgSetPath stringByAppendingPathComponent:obj];
    
    //                        NSLog(@"%@,%@",lastPath,[publicImgSetPath stringByAppendingPathComponent:obj]);
    
                            NSError *currentError;
                            [[NSFileManager defaultManager] moveItemAtPath:lastPath toPath:[publicImgSetPath stringByAppendingPathComponent:obj] error:&currentError];
                            if(currentError) {
                                NSLog(@"%@,%@",[currentImgSetPath stringByAppendingPathComponent:obj],currentError);
                            }
                        }
                    }];
                }
            }
        }];
}

- (void)testPrice {
    NSNumber *reward = @(10.0);
    CGFloat tempTotalPrice = [reward floatValue] * 100;
    
    
    NSInteger averagePrice = tempTotalPrice / 3;
    NSInteger allocatedPrice = averagePrice * 3;
    CGFloat remainPrice = tempTotalPrice - allocatedPrice;
    NSLog(@"%ld,%f",(long)averagePrice, remainPrice);
}

- (NSInteger)testReturn {
    NSMutableArray *dataArray = nil;
    return dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (nullable NSString *)testNon:(nonnull NSString *)str {
    return nil;
}

@end
