//
//  WJModuleContext.h
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

#import <UIKit/UIKit.h>
#import "WJServiceRegisterDefine.h"

/**
 模块上下文环境
 */
@protocol WJModuleContext <NSObject>

/**
 注册服务
 */
- (void)registerService:(Protocol*) serviceProtocol serviceClass:(Class) serviceClass;

/**
 注册服务
 */
- (void)registerServiceClass:(Class) serviceClass;

/**
 批量注册服务
 */
- (void)batchRegisterServices:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines;

/**
 注册服务
 */
- (void)registerService:(id<WJServiceRegisterDefine>)serviceRegisterDefine;

/**
 注册切面
 */
- (void)registerAspect:(Class)aspectClass;

/**
 注册切面
 */
- (void)batchRegisterAspects:(NSSet<Class>*)aspects;

/**
 模块id
 */
- (NSString*)moduleId;

/**
 卸载
 */
- (void)moduleDestroy;

@end
