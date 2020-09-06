//
//  RuntimeObject.m
//  Demo
//
//  Created by FaceBook on 2020/9/6.
//  Copyright © 2020 whs. All rights reserved.
//

#import "RuntimeObject.h"
#import <objc/runtime.h>

@implementation RuntimeObject

+ (void)load{
    //获取方法
    Method test = class_getInstanceMethod(self, @selector(test));
    Method otherTest = class_getInstanceMethod(self, @selector(otherTest));
    //交换两个方法的实现
    method_exchangeImplementations(test, otherTest);
}

- (void)test{
    NSLog(@"===test===");
}

- (void)otherTest{
    //实际调用test的具体实现
    [self otherTest];
    NSLog(@"===otherTest===");
}

@end
