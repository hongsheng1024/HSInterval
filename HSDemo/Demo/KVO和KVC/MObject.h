//
//  MObject.h
//  Demo
//
//  Created by FaceBook on 2020/9/7.
//  Copyright © 2020 whs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MObject : NSObject

@property(nonatomic, assign)NSInteger value;

- (void)increase;

@end

NS_ASSUME_NONNULL_END
