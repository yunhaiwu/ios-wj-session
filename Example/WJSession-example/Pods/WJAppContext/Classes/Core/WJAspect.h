//
//  WJAspect.h
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
#import "WJAppContextDefines.h"

typedef NS_OPTIONS(NSUInteger, WJAopAspectActionOption) {
    WJAopAspectActionOptionNone                 = 0,
    WJAopAspectActionOptionBefore               = 1 << 0,
    WJAopAspectActionOptionAfter                = 1 << 1,
    WJAopAspectActionOptionAround               = 1 << 2
};

/**
 aop切面
 注意：1、所有的aspect是创建成功后是单利
      2、所有aspect 最好继承AbstractAspect
 */
@protocol WJAspect <NSObject>

/**
 切入表达式
 单表达式格式：    类名(方法名)
 例：    User(login:)    表示调用User类login方法拦截
        *(*)            表示调用如何类中任何方法都会被拦截
        User(*)         标识拦截User类所有方法
        *(login:)       拦截所有login:方法
 
 多表达式格式:
        User(login:);User(logout:)  表示拦截User类 login:、logout: 方法
 */
- (NSString*)pointcutExpressions;


- (NSUInteger)aspectActionOption;

@optional

/**
 调用之前方法
 */
- (void)doBefore:(id<WJJoinPoint>)joinPoint;

/**
 调用之后方法
 */
- (void)doAfter:(id<WJJoinPoint>)joinPoint;

/**
 环绕方法
 实现此方法需要在方法中调用 proceed: 或 proceed 继续执行
 */
- (void)doAround:(id<WJProceedingJoinPoint>)joinPoint;

/**
 切面id
 default：Aspect Class Name
 */
+ (NSString*)aspectId;

/**
 所属模块id
 如果不实现则属于全局通用模块
 */
+ (NSString*)moduleId;

@end
