//
//  HSPermenantThread.m
//  Demo
//
//  Created by FaceBook on 2020/9/8.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSPermenantThread.h"
#import "HSThread.h"

@interface HSPermenantThread ()

@property(nonatomic, strong)HSThread *innerThread;
@property(nonatomic, assign)BOOL stopped;

@end


@implementation HSPermenantThread

- (instancetype)init{
    self = [super init];
    if (self) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[HSThread alloc]initWithBlock:^{
            NSLog(@"====== begin ======");
//            [[NSRunLoop currentRunLoop]addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//            while (weakSelf && !weakSelf.stopped) {
//                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            }
            
            //创建上下文
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            //向runLoop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            //销毁source
            CFRelease(source);
            //启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
            NSLog(@"====== end ======");
        }];
        [self.innerThread start];
    }
    return self;
}

- (void)executeTask:(HSPermenantThreadTask)task{
    if (!self.innerThread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop{
    if (!self.innerThread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)__stop{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(HSPermenantThreadTask)task{
    task();
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [self stop];
}

@end
