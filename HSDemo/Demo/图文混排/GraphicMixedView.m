//
//  GraphicMixedView.m
//  Demo
//
//  Created by whs on 2020/12/3.
//  Copyright © 2020 whs. All rights reserved.
//
/*
 https://www.jianshu.com/p/abe24f8bde6e?utm_campaign=hugo
 
 CTFramesetter是管理生成CTFrame的工厂类，其中记录了需要绘制的文本内容中不同字符串对应的富文本属性（加粗、颜色、字号等），通过NSAttributedString可生成CTFrameSetter。

 CTFrame描述了总的文本绘制区域的frame，通过它你可以得到在指定区域内绘制的文本一共有多少行。
 
 CTLine记录了需要绘制的单行文本信息，通过它你可以得到当前行的上行高、下行高以及行间距等信息。
 
 CTRun描述了单行文本中具有相同富文本属性的字符实体，每一行文字中可能有多个CTRun，也有可能只包含一个CTRun。如下图，这行文字中包含三个CTRun，分别为：这是 一段  测试数据
 
 CTRunDelegate用于图文混排时候的图片绘制，因为CoreText本身并不能进行图文混排，但是可以使用CTRunDelegate在需要显示图片的地方添加占位符，当CoreText绘制到该位置的时候，会触发CTRunDelegate代理，在代理方法中可以获取到该区域的大小以及图片信息，然后调用 CGContextDrawImage(c, runBounds, image.CGImage) 绘制图片即可。

 
 
 */

#import "GraphicMixedView.h"
#import <CoreText/CoreText.h>

@implementation GraphicMixedView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //获取上下文
    CGContextRef c = UIGraphicsGetCurrentContext();
    //将当前图形状态推入堆栈
    CGContextSaveGState(c);
    //设置字形变换矩阵为 ，也就是说每一个字形都不做图形变换
    CGContextSetTextMatrix(c, CGAffineTransformIdentity);
    // 坐标转换，UIKit 坐标原点在左上角，CoreText 坐标原点在左下角
    CGContextTranslateCTM(c, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(c, 1.0f, -1.0f);
    
    
    // 绘制完成，将堆栈顶部的状态弹出，返回到之前的图形状态
    CGContextRestoreGState(c);
   
}


@end
