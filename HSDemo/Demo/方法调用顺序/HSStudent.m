//
//  HSStudent.m
//  Demo
//
//  Created by FaceBook on 2020/9/3.
//  Copyright © 2020 whs. All rights reserved.
//

#import "HSStudent.h"

@implementation HSStudent

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
    }
    return self;
}

+ (void)load
{
    NSLog(@"%s", __func__);
}

+ (void)initialize
{
    NSLog(@"%s", __func__);
}

@end
