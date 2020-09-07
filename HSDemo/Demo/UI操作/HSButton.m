//
//  HSButton.m
//  Demo
//
//  Created by FaceBook on 2020/9/7.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSButton.h"

@implementation HSButton


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (!self.userInteractionEnabled || [self isHidden] || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        //遍历当前对象的子视图
        __block UIView *hit = nil;
        [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse
                                        usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //坐标转换
            CGPoint vonvertPoint = [self convertPoint:point toView:obj];
            //调用子视图的hitTest方法
            hit = [obj hitTest:vonvertPoint withEvent:event];
            //如果找到了接收事件的对象，则停止遍历
            if (hit) {
                *stop = YES;
            }
        }];
        if (hit) {
            return hit;
        }else{
            return self;
        }
    }else{
        return nil;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGFloat x1 = point.x;
    CGFloat y1 = point.y;
    
    CGFloat x2 = self.frame.size.width/2;
    CGFloat y2 = self.frame.size.height/2;
    double dis = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    //在以当前控件中心为圆心半径为当前控件宽度的圆内
    if (dis <= self.frame.size.width/2) {
        return YES;
    }else{
        return NO;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
