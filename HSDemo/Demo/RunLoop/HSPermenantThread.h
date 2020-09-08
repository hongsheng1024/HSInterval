//
//  HSPermenantThread.h
//  Demo
//
//  Created by FaceBook on 2020/9/8.
//  Copyright © 2020 whs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^HSPermenantThreadTask)(void);

@interface HSPermenantThread : NSObject


//在当前子线程执行一个任务
- (void)executeTask:(HSPermenantThreadTask)task;

//结束线程
- (void)stop;


@end

NS_ASSUME_NONNULL_END
