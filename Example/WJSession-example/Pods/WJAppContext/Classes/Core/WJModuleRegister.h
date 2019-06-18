//
//  WJModuleRegister.h
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
#import "WJModuleRegisterDefine.h"

/**
 模块注册器
 */
@protocol WJModuleRegister <NSObject>

/**
 注册模块
 */
- (void)registerModule:(Class)moduleClass;

/**
 注册模块
 */
- (void)registerModuleByDefine:(id<WJModuleRegisterDefine>)moduleRegisterDefine;

@end
