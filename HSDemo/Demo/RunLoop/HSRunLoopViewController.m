//
//  HSRunLoopViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//

/*
 1、RunLoop是通过内部维护的事件循环来对事件/消息进行管理的一个对象。
 2、事件循环是什么呢？
    没有消息需要处理时，休眠以避免资源占用；用户态 -> 内核态
    有消息需要处理时，立刻被唤醒；
 
 3、数据结构
    NSRunLoop是CFRunLoop的封装，提供了面向对象的API;
    CFRunLoop
        pthread 线程对象
        currentMode 当前所处的模式
        modes 多个model的集合
        commonModes
        commonModeItems
    CFRunLoopMode
        name   对应model名称
        sources0 需要手动唤醒线程
        sources1 具备唤醒线程的能力
        observers
        timers
    Source
    Timer
    Observer
        观测时间点
        kCFRunLoopEntry   RunLoop入口时机
        kCFRunLoopBeforeTimers 通知观察者RunLoop将要对timer事件进行处理了
        kCFRunLoopBeforeSources 通知观察者RunLoop将要对source事件进行处理了
        kCFRunLoopBeforeWaiting 通知对应观察者当前RunLoop将要进入休眠状态  将要用户态切内核态
        kCFRunLoopAfterWaiting  内核态切用户态之后不久
        kCFRunLoopExit RunLoop退出的通知
 
 5、RunLoop的Mode
    NSRunLoopCommonModes
        CommonModes不是实际存在的一种Mode;
        是同步Source/Timer/Observer到多个Mode中的一种技术方案；
 
 6、线程唤醒的条件
    Source1
    Timer事件
    外部手动唤醒
 
 7、RunLoop与多线程
    线程是和RunLoop一一对应的；
    自己创建的线程默认是没有RunLoop的；
 
 8、怎样实现一个常驻线程呢？
    (1)为当前线程开启一个RunLoop;
    (2)向该RunLoop中添加一个Port/Source等维持RunLoop的事件循环；
    (3)启动该RunLoop;
 
 */

#import "HSRunLoopViewController.h"
#import "HSProxy.h"
#import "HSThread.h"
#import "HSPermenantThread.h"

@interface HSRunLoopViewController ()

@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, strong)HSThread *hsThread;
@property (assign, nonatomic, getter=isStoped) BOOL stopped;
@property(nonatomic, strong)HSPermenantThread *thread;

@end

@implementation HSRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(runTest) withObject:nil afterDelay:2.0];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(100, 100, 100, 150)];
    _textView.backgroundColor = [UIColor cyanColor];
    _textView.text = @"收到了就发生了福建省劳动纠纷及三闾大夫结束了就发生了计算机房是雷锋精神了极乐世界风景所发生的范德萨是老骥伏枥手机费上飞机失联飞机上上飞机了酸辣粉江苏龙卷风失联飞机失联飞机上了尖峰时刻拒绝垃圾分类介绍是否极乐世界发生六块腹肌 绿色减肥零食减肥了司法局时所发生六块腹肌舒服收到了就发生了福建省劳动纠纷及三闾大夫结束了就发生了计算机房是雷锋精神了极乐世界风景所发生的范德萨是老骥伏枥手机费上飞机失联飞机上上飞机了酸辣粉江苏龙卷风失联飞机失联飞机上了尖峰时刻拒绝垃圾分类介绍是否极乐世界发生六块腹肌 绿色减肥零食减肥了司法局时所发生六块腹肌舒服";
    [self.view addSubview:_textView];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(100, 300, 90, 45);
    [stopBtn setBackgroundColor:[UIColor cyanColor]];
    [stopBtn setTitle:@"暂定线程保活" forState:UIControlStateNormal];
    stopBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [stopBtn addTarget:self action:@selector(stopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    //[self test1];
    
    //[self test2];
    [self test3];
}

//保活封装
- (void)test3{
    self.thread = [[HSPermenantThread alloc]init];
}


#pragma mark - 滚动视图、定时器，滚动时定时器失效解决方案
- (void)test1{
    static int count = 0;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%d", ++count);
    }];
    //要添加模式，不然定时器不会执行
    // NSDefaultRunLoopMode、UITrackingRunLoopMode才是真正存在的模式
    // NSRunLoopCommonModes并不是一个真的模式，它只是一个标记
    // timer能在_commonModes数组中存放的模式下工作
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 线程保活
- (void)test2{
    //self.hsThread = [[HSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
    
    __weak typeof(self) weakSelf = self;
    
    self.stopped = NO;
    self.hsThread = [[HSThread alloc] initWithBlock:^{
        NSLog(@"%@----begin----", [NSThread currentThread]);
        
        // 往RunLoop里面添加Source\Timer\Observer
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    
        while (weakSelf && !weakSelf.isStoped) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"%@----end----", [NSThread currentThread]);
    }];
    [self.hsThread start];
    
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
    return;
    
    if (!self.hsThread) {
        return;
    }
    [self performSelector:@selector(runTest) onThread:self.hsThread withObject:nil waitUntilDone:NO];
    NSLog(@"%s", __func__);
}

// 子线程需要执行的任务
- (void)runTest
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (void)stopBtnAction:(UIButton *)btn{
    [self.thread stop];
    return;
    // 在子线程调用stop（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(stopRun) onThread:self.hsThread withObject:nil waitUntilDone:YES];
}

//用于停止子线程的RunLoop
- (void)stopRun{
    self.stopped = YES;
    //停止runLoop;
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s---%@", __func__, [NSThread currentThread]);
    //清空线程
    self.hsThread = nil;
}


//线程保活
//- (void)run{
//    NSLog(@"%s", __func__);
//    // 往RunLoop里面添加Source\Timer\Observer
//    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//    // NSRunLoop的run方法是无法停止的，它专门用于开启一个永不销毁的线程（NSRunLoop）
//    [[NSRunLoop currentRunLoop]run];
//    NSLog(@"%s --- end ---", __func__);
//}

- (void)dealloc{
    NSLog(@"%s", __func__);
    //[self stopBtnAction:nil];
    [self.thread stop];
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
