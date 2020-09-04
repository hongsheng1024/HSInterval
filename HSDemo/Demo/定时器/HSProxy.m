//
//  HSProxy.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSProxy.h"

@implementation HSProxy

+ (instancetype)proxyWithTarget:(id)target{
    //NSProxy对象不需要调用init，因为它本来就没有init方法
    HSProxy *hsProxy = [HSProxy alloc];
    hsProxy.target = target;
    return hsProxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}


@end
