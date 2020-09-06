//
//  HSTimerViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSTimerViewController.h"
#import "HSProxy.h"
#import "HSTimer.h"

@interface HSTimerViewController ()

@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)CADisplayLink *link;
@property(nonatomic, strong)dispatch_source_t gcdTimer;

@property(nonatomic, strong)NSString *task;

@end

@implementation HSTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self memoryLeakForTimer];
    
    //定时器封装 GCD
    NSLog(@"===begin===");
//    self.task = [HSTimer execTask:^{
//        NSLog(@"11111--%@", [NSThread currentThread]);
//    } start:2.0 interval:1.0 repeats:NO async:NO];
    self.task = [HSTimer execTask:[HSProxy proxyWithTarget:self]
                         selector:@selector(timerTest)
                            start:2.0
                         interval:1.0
                          repeats:YES
                            async:NO];
    NSLog(@"===end===");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [HSTimer cancelTask:self.task];
    self.task = nil;
}

#pragma mark - 定时器
- (void)memoryLeakForTimer{
   
    //1、这种方法会产生循环引用 self -> timer -> self
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    //2、使用block timer无target 不会对self产生强引用
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf timerTest];
//    }];
    
    //3、使用中间类，打断循环链
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[HSProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    //4、使用 CADisplayLink
//    self.link = [CADisplayLink displayLinkWithTarget:[HSProxy proxyWithTarget:self] selector:@selector(timerTest)];
//    self.link.preferredFramesPerSecond = 1.0;
//    //添加到runloop，不然不会被触发 https://www.jianshu.com/p/626db598c7c3
//    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    //5、NSTimer依赖于RunLoop，如果RunLoop的任务过于繁重，可能会导致NSTimer不准时，而GCD的定时器会更加准时
    __block int count = 0;
    //获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置时间 2秒后每隔1秒开始执行
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.gcdTimer, start, interval, 0);
    //设置回调
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        NSLog(@"--------%@", [NSThread currentThread]);
        count++;
        if (count == 6) {
            //取消定时器
            dispatch_source_cancel(weakSelf.gcdTimer);
            weakSelf.gcdTimer = nil;
        }
    });
    //启动定时器
    dispatch_resume(self.gcdTimer);
}

- (void)timerTest{
    NSLog(@"%s", __func__);
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.link) {
        [self.link invalidate];
        self.link = nil;
    }
    
    if (self.gcdTimer) {
        //取消定时器
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
    if (self.task) {
        [HSTimer cancelTask:self.task];
    }
    
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
