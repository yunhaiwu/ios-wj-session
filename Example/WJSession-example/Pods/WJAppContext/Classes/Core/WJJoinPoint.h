//
//  WJJoinPoint.h
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


@protocol WJJoinPoint <NSObject>

/**
 方法名称
 */
- (SEL)aopSelector;

/**
 拦截目标
 */
- (id)aopTarget;

/**
 参数个数
 */
- (NSUInteger)numberOfArguments;

/**
 获取参数方法
 */
- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

@end







@protocol WJProceedingJoinPoint <WJJoinPoint>

/**
 重置参数方法
 */
- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

/**
 以原有方法继续执行
 */
- (void)proceed;

/**
 是否已执行
 */
- (BOOL)isPerformed;

@end
