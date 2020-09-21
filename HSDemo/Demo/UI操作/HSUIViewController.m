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
    [self addImv02];
    //[self hitTest];
}


#pragma mark - 圆角
//使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
- (void)addImv01{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 300, 200)];
    imageView.image = [UIImage imageNamed:@"001"];
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
    [imageView drawRect:imageView.bounds];

    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
     //结束画图
    UIGraphicsEndImageContext();
    [self.view addSubview:imageView];
    
}
//使用CAShapeLayer和UIBezierPath设置圆角
//对内存的消耗最少啊，而且渲染快速
- (void)addImv02{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"001"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    [self.view addSubview:imageView];
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
