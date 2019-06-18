//
//  WJAppContextPreloadDatas.h
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
#import "WJServiceRegisterDefine.h"

@interface WJAppContextPreloadDatas : NSObject

+ (instancetype)sharedInstance;

/**
 获得预加载模块列表
 */
- (NSSet<Class>*)getPreloadModules;

/**
 根据moduleId获得预加载ServiceDefines
 */
- (NSSet<id<WJServiceRegisterDefine>>*)getPreloadServiceDefinesByModuleId:(NSString*)moduleId;

/**
 根据moduleId获得预加载Aspects
 */
- (NSSet<Class>*)getPreloadAspectsByModuleId:(NSString*)moduleId;


@end
