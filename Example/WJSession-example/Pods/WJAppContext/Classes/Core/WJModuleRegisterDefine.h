//
//  WJModuleRegisterDefine.h
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

/**
 模块注册描述协议
 */
@protocol WJModuleRegisterDefine <NSObject>

/**
 模块类型
 */
- (Class)moduleClass;

/**
 模块服务注册描述
 */
- (NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines;

/**
 切面注册定义
 */
- (NSSet<Class>*)aspectClassSet;

@end
