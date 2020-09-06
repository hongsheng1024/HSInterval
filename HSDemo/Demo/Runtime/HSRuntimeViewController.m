//
//  HSRuntimeViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/2.
//  Copyright © 2020 whs. All rights reserved.
//
/*
 1、数据结构
 2、类对象与元类对象
 3、消息传递
 4、方法缓存
 5、消息转发
 6、方法交换
 7、动态添加方法
 8、动态方法解析
 
 
 */


#import "HSRuntimeViewController.h"
#import "HSMobile.h"
#import "HSPhone.h"
#import "RuntimeObject.h"

@interface HSRuntimeViewController ()

@end

@implementation HSRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HSPhone *hsPhone = [[HSPhone alloc]init];
    [hsPhone test];
    
    RuntimeObject *obj = [[RuntimeObject alloc]init];
    [obj otherTest];
    
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
