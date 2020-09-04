//
//  HSProxy.h
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSProxy : NSProxy

@property(nonatomic, weak)id target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END

/*
 虽然NSProxy和class NSObject都定义了-forwardInvocation:和-methodSignatureForSelector:，但这两个方法并没有在protocol NSObject中声明；两者对这俩方法的调用逻辑更是完全不同。

 对于class NSObject而言，接收到消息后先去自身的方法列表里找匹配的selector，如果找不到，会沿着继承体系去superclass的方法列表找；如果还找不到，先后会经过+resolveInstanceMethod:和-forwardingTargetForSelector:处理，处理失败后，才会到-methodSignatureForSelector:/-forwardInvocation:进行最后的挣扎。更详细的叙述，详见NSObject的消息转发机制。

 但对于NSProxy，接收unknown selector后，直接回调-methodSignatureForSelector:/-forwardInvocation:，消息转发过程比class NSObject要简单得多。

 作者：洲洲哥
 链接：https://www.jianshu.com/p/f9eb036b841c
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 
 如果继承了NSObject 使用isKindOfClass返回0；
 如果继承了NSProxy 使用isKindOfClass返回1；target意义就变了。
 
 ViewController *vc = [[ViewController alloc] init];
 
 MJProxy *proxy1 = [MJProxy proxyWithTarget:vc];
 
 MJProxy1 *proxy2 = [MJProxy1 proxyWithTarget:vc];
 
 NSLog(@"%d %d",
       [proxy1 isKindOfClass:[ViewController class]],
       
       [proxy2 isKindOfClass:[ViewController class]]);
 
 
 
 */
