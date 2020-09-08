//
//  MObserver.m
//  Demo
//
//  Created by FaceBook on 2020/9/7.
//  Copyright © 2020 whs. All rights reserved.
//

#import "MObserver.h"
#import "MObject.h"

@implementation MObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[MObject class]] && [keyPath isEqualToString:@"value"]) {
        //获取新的value值
        NSNumber *valueNum = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"value is %@", valueNum);
    }
    
    
}


@end
