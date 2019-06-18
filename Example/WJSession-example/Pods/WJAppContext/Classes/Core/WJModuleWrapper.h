//
//  WJModuleWrapper.h
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
#import "WJServiceRegister.h"
#import "WJAspectRegister.h"
#import "WJModule.h"

typedef NS_OPTIONS(NSInteger, WJModuleStatus) {
    WJModuleStatusNone              = 0,
    WJModuleStatusInitialized       = 1 << 0,
    WJModuleStatusLoading           = 1 << 1,
    WJModuleStatusLoaded            = 1 << 2,
    WJModuleStatusDestroyed         = 1 << 3,
};

/**
 模块包装类
 */
@interface WJModuleWrapper : NSObject

/**
 当前模块状态
 */
@property (nonatomic, assign, readonly) WJModuleStatus modStatus;

/**
 初始化方法
 */
- (instancetype)initWithModuleClass:(Class)modClass servicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister;

/**
 模块对象
 */
- (id<WJModule>)getModuleObject;

/**
 模块Id
 */
- (NSString*)moduleId;

/**
 模块优先级
 */
- (int)modulePriority;

/**
 出发初始化操作
 */
- (void)triggerModuleInitAction;

/**
 触发模块卸载
 */
- (void)triggerModuleDestroyAction:(void(^)(id<WJModule> module))actionBlock;

/**
 触发模块加载操作
 */
- (void)triggerModuleLoadingAction:(void(^)(id<WJModule> module))actionBlock;

/**
 触发其他模块卸载完成操作
 */
- (void)triggerOtherModulesDestroyAction:(NSString*)destModId;

@end
