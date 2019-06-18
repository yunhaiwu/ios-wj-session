//
//  WJModule.h
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
#import <UIKit/UIKit.h>
#import "WJModuleContext.h"
#import "WJAppContextDefines.h"

#define WJ_MODULE_LOADING_PRIORITY_HIGH           100
#define WJ_MODULE_LOADING_PRIORITY_DEFAULT         50
#define WJ_MODULE_LOADING_PRIORITY_LOW              0

//模块接口
@protocol WJModule <UIApplicationDelegate>

/**
 模块环境
 不要重写此方法
 */
- (id<WJModuleContext>)modContext;

/**
 模块id，
 default：ClassName
 */
+ (NSString*)moduleId;

/**
 加载优先级
 0~100，值越大越优先加载，默认值：50
 */
+ (int)modPriority;


@optional

/**
 模块初始化
 */
- (void)onModuleInit:(id<WJModuleContext>)context;

/**
 准备加载
 */
- (void)onModuleWillLoad:(id<WJModuleContext>)context;

/**
 已加载
 */
- (void)onModuleDidLoad:(id<WJModuleContext>)context;

/**
 准备卸载
 */
- (void)onModuleWillDestroy:(id<WJModuleContext>)context;

/**
 已卸载
 */
- (void)onModuleDidDestroy:(id<WJModuleContext>)context;

/**
 其他模块销毁通知
 */
- (void)onModuleDidOtherModuleDestroyNotify:(NSString*)moduleId;

@end
