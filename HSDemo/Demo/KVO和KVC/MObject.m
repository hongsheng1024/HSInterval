//
//  MObject.m
//  Demo
//
//  Created by FaceBook on 2020/9/7.
//  Copyright © 2020 whs. All rights reserved.
//

#import "MObject.h"

@implementation MObject

- (instancetype)init{
    self = [super init];
    if (self) {
        _value = 0;
    }
    return self;
}

- (void)increase{
    //模拟
    [self willChangeValueForKey:@"value"];
    _value += 1;
    [self didChangeValueForKey:@"value"];
}


@end
