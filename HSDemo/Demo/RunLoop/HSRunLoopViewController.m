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

@interface HSRunLoopViewController ()

@end

@implementation HSRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
