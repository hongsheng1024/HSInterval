//
//  HSThreadController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//

/*
 1、NSOperation需要和NSOperationQueue配合使用来实现线程方案；
    特点：
        添加任务依赖；
        任务执行状态控制；
        控制最大并发量；
    状态控制：
        如果只重写main方法，底层控制变更任务执行完成状态，以及任务退出；
        如果重写了start方法，自行控制任务状态；
 
  2、锁
    @synchronized
        一般在创建单例对象的时候使用，来保证在多线程环境下创建单例对象是唯一的。
    atomic
        修饰属性的关键字
        对被修饰对象进行原子操作（不负责使用）
    OSSPinLock 自旋锁
        循环等待询问，不释放当前资源；
        用于轻量级数据访问，简单的int值 +1/-1操作；
    NSLock
    NSRecursiveLock 递归锁
    dispatch_semaphore_t 信号量
        
 
 
 */


#import "HSThreadController.h"
#import "HSOperation.h"

@interface HSThreadController ()


@end

@implementation HSThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self gcdTest];
    return;
    
    {
        
        
        
    }
    
    {
        /*
         除了主线程，其它线程默认是没有开启runLoop的，performSelector方法即使延时0秒后提交printLog任务，
         也是要有提交任务到runLoop逻辑的，此时没有runLoop，所以performSelector方法失效了。
         */
        
        //异步并发 打印 1、3
        dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);
        dispatch_async(global_queue, ^{
            NSLog(@"1");
            [self performSelector:@selector(printLog) withObject:nil afterDelay:0];
            NSLog(@"3");
        });
        
        
    }
    
    
    {
        //异步串行
        dispatch_async(dispatch_get_main_queue(), ^{
            [self doSomething];
        });
        
    }
    
    {
        //同步并发
        NSLog(@"1");
        dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
        dispatch_sync(globalQueue, ^{
            NSLog(@"2");
            dispatch_sync(globalQueue, ^{
                NSLog(@"3");
            });
            NSLog(@"4");
        });
        NSLog(@"5");
    }
    
    {
        /*
         主队列、串行队列、主线程
         主队列：viewDidLoad
         串行队列：Block
         互不影响
         任务都同步分派到一个队列就会产生循环等待的问题
         */
        
        //串行同步
        dispatch_queue_t serialQueue = dispatch_queue_create([@"serialQueue" UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_sync(serialQueue, ^{
            [self doSomething];
        });
        
        
    }
    
    
    {
        //主队列同步
        /*
         产生死锁
         死锁的原因：队列引起的循环等待
         主队列中首先提交了viewDidLoad任务，之后提交了一个Block任务，不论是哪一个最终都要分配到主线程中去执行；
         现在分配viewDidLoad到主线程去处理，在它执行过程中需要调用Block，当Block同步调用完成之后viewDidLoad方法
         才能继续向下走。
         viewDidLoad方法的调用结束或者完成需要依赖与在主队列后续提交的Block任务；而在主队列的Block任务要想执行依赖于
         主队列的性质先进先出，它要等到viewDidLoad处理完成，才能执行。两者相互等待，引发死锁。
         
         */
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self doSomething];
//        });
    }
    
    
    
    //[self operationTest];
}

- (void)printLog{
    NSLog(@"2");
}

- (void)doSomething{
    NSLog(@"%s---%@", __func__, [NSThread currentThread]);
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
    
    //栅栏函数 http://www.cocoachina.com/articles/28766
    //https://www.jianshu.com/p/e4d5b26b6a36
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
    //https://www.cnblogs.com/whongs/p/9149561.html
    //https://www.jianshu.com/p/4b1d77054b35
    NSLog(@"11111");
    //NSOperation 单独使用时系统同步执行操作，配合 NSOperationQueue 我们能更好的实现异步执行。
//    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
//    [invocationOperation start];
    
    
    //addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行
//    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"任务一 --- %@", [NSThread currentThread]);
//    }];
//
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"任务二 --- %@", [NSThread currentThread]);
//    }];
//
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"任务三 --- %@", [NSThread currentThread]);
//    }];
//
//    [blockOperation start];
    
   //添加依赖
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
//    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
//
//    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"任务3--%@", [NSThread currentThread]);
//    }];
//
//    [queue addOperation:op1];
//    [queue addOperation:op2];
//    [queue addOperation:op3];
    
    
//    NSOperationQueue *queue001 = [[NSOperationQueue alloc]init];
//    [queue001 addOperationWithBlock:^{
//        NSLog(@"异步任务");
//
//        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            NSLog(@"回到主线程");
//        }];
//    }];
//
    
    NSLog(@"22222");
    
    
    
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
