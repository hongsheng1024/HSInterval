//
//  HSDrawViewController.m
//  Demo
//
//  Created by whs on 2020/11/29.
//  Copyright © 2020 whs. All rights reserved.
//
/*
 iOS系统本身提供了两套绘图的框架，即UIBezierPath 和 Core Graphics。而前者所属UIKit，其实是对Core Graphics框架关于path的进一步封装，所以使用起来比较简单。但是毕竟Core Graphics更接近底层，所以它更加强大。

 
 
 */

#import "HSDrawViewController.h"
#import "UIViewExt.h"

@interface HSDrawViewController ()

@end

@implementation HSDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(100, 100, 100, 100);
        shapeLayer.fillColor = [UIColor redColor].CGColor;
        shapeLayer.lineWidth = 1.0f;
        //创建圆形贝塞尔曲线
        //UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:50 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        shapeLayer.path = circlePath.CGPath;
        //[self.view.layer addSublayer:shapeLayer];
    }
    {
        UIBezierPath *aPath = [UIBezierPath bezierPath];
        [aPath moveToPoint:CGPointMake(100, 100)];
        [aPath addLineToPoint:CGPointMake(60, 140)];
        [aPath addLineToPoint:CGPointMake(60, 240)];
        [aPath addLineToPoint:CGPointMake(160, 240)];
        [aPath addLineToPoint:CGPointMake(160, 140)];
        [aPath closePath];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [UIColor redColor].CGColor; //边框颜色
        shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        shapeLayer.path = aPath.CGPath;
        //[self.view.layer addSublayer:shapeLayer];
    }
    {
        //虚线
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.view.bounds];
        [shapeLayer setPosition:self.view.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        // 设置虚线颜色为blackColor
        [shapeLayer setStrokeColor:[[UIColor redColor] CGColor]];
        
        // 3.0f设置虚线的宽度
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
          [NSNumber numberWithInt:1],nil]];
        
        // Setup the path
        //        CGMutablePathRef path = CGPathCreateMutable();
        //        CGPathMoveToPoint(path, NULL, 0, 89);
        //        CGPathAddLineToPoint(path, NULL, 320,89);
        //
        //        [shapeLayer setPath:path];
        //        CGPathRelease(path);
        UIBezierPath *aPath = [UIBezierPath bezierPath];
        [aPath moveToPoint:CGPointMake(100, 100)];
        [aPath addLineToPoint:CGPointMake(60, 140)];
        [aPath addLineToPoint:CGPointMake(60, 240)];
        [aPath addLineToPoint:CGPointMake(160, 240)];
        [aPath addLineToPoint:CGPointMake(160, 140)];
        [aPath closePath];
        shapeLayer.path = aPath.CGPath;
        //[self.view.layer addSublayer:shapeLayer];
    }
    {
        //弧线
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        aPath.lineWidth = 5.0;
        aPath.lineCapStyle = kCGLineCapRound; //线条拐角
        aPath.lineJoinStyle = kCGLineCapRound; //终点处理
        [aPath moveToPoint:CGPointMake(20, 300)];
        [aPath addLineToPoint:CGPointMake(80, 300)];
        [aPath addLineToPoint:CGPointMake(80, 350)];
        //[aPath addQuadCurveToPoint:CGPointMake(120, 300) controlPoint:CGPointMake(70, 200)];
        //[aPath closePath];
        
        CAShapeLayer *CurvedLineLayer=[CAShapeLayer layer];
        CurvedLineLayer.path=aPath.CGPath;
        [CurvedLineLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为blackColor
        [CurvedLineLayer setStrokeColor:[[UIColor redColor] CGColor]];
        [self.view.layer addSublayer:CurvedLineLayer];
    }
    
}

@end

@implementation DrawView



@end
