//
//  WJModuleContainer.h
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
#import "WJModule.h"
#import "WJModuleContext.h"
#import "WJModuleRegister.h"
#import "WJServiceRegister.h"
#import "WJAspectRegister.h"

/**
 模块容器，模块管理，注册、卸载、应用程序回调分发
 */
@interface WJModuleContainer : NSObject<WJModuleRegister, UIApplicationDelegate>

/**
 初始化方法
 */
- (instancetype)initWithServicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister;

/**
 根据模块id获取模块对象
 */
- (id<WJModule>)getModuleById:(NSString*)moduleId;

/**
 全局默认模块
 */
- (id<WJModule>)globalDefaultModule;

/**
 卸载模块
 */
- (void)unRegisterModule:(Class)modClass;

@end
