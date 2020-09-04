//
//  HSThreadController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSThreadController.h"

@interface HSThreadController ()


@end

@implementation HSThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self gcdTest];
}

- (void)threadTest{
    //https://www.cnblogs.com/whongs/p/9149945.html
    //1、创建线程后启动线程
    //NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
    //[thread start];
    
    //2、创建线程后自动启动线程
    //[NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    
    //3、隐式创建并启动线程
    [self performSelectorInBackground:@selector(run) withObject:nil];
    
}

- (void)gcdTest{
    //https://www.cnblogs.com/whongs/p/9147914.html
    //创建队列
    dispatch_queue_t queueSerial = dispatch_queue_create([@"serial" UTF8String], DISPATCH_QUEUE_SERIAL); //串行队列
    dispatch_queue_t queueConcurrent = dispatch_queue_create([@"concurrent" UTF8String], DISPATCH_QUEUE_CONCURRENT);//并行队列
    dispatch_queue_t queueMain = dispatch_get_main_queue(); //主队列
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(0, 0); //全局并发队列
    
    //主队列同步执行会报错；
    //1、同步执行--- 除了主队列会报错，其它都在主线程顺序执行，不会开辟新线程
    //2、异步执行--- 无序，可能到最后执行了，除了主队列会在主线程中执行任务，其它会开辟新线程，在新线程中执行任务。
    //3、并行异步可能会开辟多个新线程，串行异步会开辟一个新线程；
    
    NSLog(@"开始了111");
//    dispatch_sync(queueSerial, ^{
//        NSLog(@"同步执行01---%@", [NSThread currentThread]);
//    });
//    dispatch_sync(queueSerial, ^{
//        NSLog(@"同步执行02---%@", [NSThread currentThread]);
//    });
    
    
//    dispatch_async(queueGlobal, ^{
//        NSLog(@"异步执行01---%@", [NSThread currentThread]);
//    });
//    dispatch_async(queueGlobal, ^{
//        NSLog(@"异步执行02---%@", [NSThread currentThread]);
//    });

    //队列组 中的任务执行完毕 再执行dispatch_group_notify
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, queueGlobal, ^{
//        NSLog(@"队列组追加任务1---%@", [NSThread currentThread]);
//    });
//    dispatch_group_async(group, queueGlobal, ^{
//        NSLog(@"队列组追加任务2---%@", [NSThread currentThread]);
//    });
//    dispatch_group_notify(group, queueMain, ^{
//        NSLog(@"等待前面任务完成再执行---%@", [NSThread currentThread]);
//    });
//
//    dispatch_group_async(group, queueGlobal, ^{
//        NSLog(@"队列组追加任务3---%@", [NSThread currentThread]);
//    });
    
    //栅栏函数
    dispatch_async(queueConcurrent, ^{
        NSLog(@"栅栏函数追加任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queueConcurrent, ^{
        NSLog(@"栅栏函数追加任务2---%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queueConcurrent, ^{
        NSLog(@"栅栏函数--追加任务3---%@", [NSThread currentThread]);
    });
    
    dispatch_async(queueConcurrent, ^{
        NSLog(@"栅栏函数追加任务4---%@", [NSThread currentThread]);
    });
    
    NSLog(@"结束了222");
}

- (void)operationTest{
    
}

- (void)run{
    NSLog(@"%s---%@", __func__, [NSThread currentThread]);
}

- (void)dealloc{
    NSLog(@"%s", __func__);
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
