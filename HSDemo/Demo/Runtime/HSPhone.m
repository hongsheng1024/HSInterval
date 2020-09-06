//
//  HSPhone.m
//  Demo
//
//  Created by FaceBook on 2020/9/6.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSPhone.h"
#import <objc/runtime.h>

@implementation HSPhone

void testImp(void){
    NSLog(@"test invoke");
}

- (id)init{
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class])); //HSPhone
        NSLog(@"%@", NSStringFromClass([super class]));//HSPhone
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    if (sel == @selector(test)) {
        //动态添加test方法的实现
        class_addMethod(self, @selector(test), testImp, [@"v@:" UTF8String]);
        return YES; //解决了实例方法的调用
        
        //如果是test方法，打印日志；
        NSLog(@"%s", __func__);
        return NO;
    }else{
        //如果不是返回父类的默认调用
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"%s", __func__);
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == @selector(test)) {
        NSLog(@"%s", __func__);
        //参数说明：v返回类型void   @：当前对象self  ：：选择器
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"%s", __func__);
}


@end
