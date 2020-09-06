//
//  HSBlock.m
//  Demo
//
//  Created by FaceBook on 2020/9/4.
//  Copyright © 2020 whs. All rights reserved.
//

//clang -rewrite-objc HSBlock.m 源码解析

#import "HSBlock.h"

@implementation HSBlock

- (void)method{
    
        int multiplier = 6;
        int(^Block)(int) = ^int(int num){
            return num * multiplier;
        };
        Block(2);
    
}



@end
