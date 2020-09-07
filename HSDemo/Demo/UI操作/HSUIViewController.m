//
//  HSUIViewController.m
//  Demo
//
//  Created by FaceBook on 2020/9/7.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSUIViewController.h"
#import "HSButton.h"

@interface HSUIViewController ()

@property(nonatomic, strong)HSButton *hsButton;

@end

@implementation HSUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hitTest];
}

#pragma mark - 事件响应 方形按钮圆形区域响应点击事件
- (void)hitTest{
    _hsButton = [[HSButton alloc]initWithFrame:CGRectMake(100, 100, 120, 120)];
    [_hsButton setBackgroundColor:[UIColor blueColor]];
    [_hsButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hsButton];
}

- (void)doAction:(id)sender{
    NSLog(@"%s", __func__);
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
