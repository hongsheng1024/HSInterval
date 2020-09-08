//
//  HSKVViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/3.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSKVViewController.h"
#import "MObject.h"
#import "MObserver.h"

@interface HSKVViewController ()

@end

@implementation HSKVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MObject *obj = [[MObject alloc]init];
    MObserver *observer = [[MObserver alloc]init];
    
    //调用KVO方法监听obj的value属性的变化
    [obj addObserver:observer forKeyPath:@"value"
             options:NSKeyValueObservingOptionNew context:NULL];
    
    //通过setter方法修改value
    obj.value = 1;
    
    /*
     使用setter方法改变值KVO才会生效；
     使用setValue:forKey: 改变值KVO才会生效；
     成员变量直接修改需手动添加两个方法KVO才会生效;
     willChangeValueForKey:
     didChangeValueForKey:
     
     */
    
    //1、通过kvc设置value能否生效？ 可以
    [obj setValue:@"2" forKey:@"value"];
    
    //2、通过成员变量直接复制value能否生效？
    [obj increase];
    
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
