//
//  SimpleAspectJoinPoint.h
//  WJAppContext
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by Yunhai.Wu
//  Copyright © 2018年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJJoinPoint.h"

/**
 连接点
 */
@interface SimpleAspectJoinPoint : NSObject<WJProceedingJoinPoint>

- (instancetype)initWithInvocation:(NSInvocation*)invocation;

- (NSInvocation*)getInvocation;

@end

