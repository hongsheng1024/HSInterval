//
//  HSLoadViewController.h
//  Demo
//
//  Created by FaceBook on 2020/9/3.
//  Copyright © 2020 whs. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSLoadViewController : BaseViewController

@end

NS_ASSUME_NONNULL_END

/*
 load、initialize方法的区别什么？
 1.调用方式
 1> load是根据函数地址直接调用
 2> initialize是通过objc_msgSend调用

 2.调用时刻
 1> load是runtime加载类、分类的时候调用（只会调用1次）
 2> initialize是类第一次接收到消息的时候调用，每一个类只会initialize一次（父类的initialize方法可能会被调用多次）

 load、initialize的调用顺序？
 1.load
 1> 先调用类的load
 a) 先编译的类，优先调用load
 b) 调用子类的load之前，会先调用父类的load

 2> 再调用分类的load
 a) 先编译的分类，优先调用load

 2.initialize
 1> 先初始化父类
 2> 再初始化子类（可能最终调用的是父类的initialize方法）
 
 
 分类的调用顺序
 一个类的多个分类中后编译的先调用
 
 
 */
