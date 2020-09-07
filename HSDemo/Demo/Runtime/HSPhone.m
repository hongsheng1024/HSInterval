//
//  HSPhone.m
//  Demo
//
//  Created by FaceBook on 2020/9/6.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSPhone.h"
#import <objc/runtime.h>
#import "RuntimeObject.h"

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
    NSLog(@"%s", __func__);
    if (sel == @selector(test)) {
        
        //如果在这一步骤返回的是YES或者给予这个方法选择器所对应的方法一个实现的话，
        //相当于通知系统当前消息已处理，也就结束了消息转发流程
        //动态添加test方法的实现
        //class_addMethod(self, @selector(test), testImp, [@"v@:" UTF8String]);
        //return YES; //解决了实例方法的调用
        
        //如果是test方法，打印日志；
        return NO;
    }else{
        //如果不是返回父类的默认调用
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    /*
     返回值是一个id，相当于告诉系统这个选择器或者这次实例方法的调用应该有哪个对象来处理，转发对象是谁，
     如果指定了一个转发目标的话，系统会把这条消息转发给返回的转发目标，同时会结束当前的消息转发流程。
     */
    NSLog(@"%s", __func__);
//    if (aSelector == @selector(test)) {
//        return [[RuntimeObject alloc]init];
//    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"%s", __func__);
    if (aSelector == @selector(test)) {
        //参数说明：v返回类型void   @：当前对象self  ：：选择器
        //return [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return [[RuntimeObject new]methodSignatureForSelector:aSelector];
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"%s", __func__);
    if ([NSStringFromSelector(anInvocation.selector) isEqualToString:@"test"]) {
        [anInvocation invokeWithTarget:[RuntimeObject new]];
    }else{
        [super forwardInvocation:anInvocation];
    }
}


@end
