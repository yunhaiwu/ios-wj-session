//
//  SimpleModuleRegisterDefine.h
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
#import "WJModuleRegisterDefine.h"
#import "WJServiceRegisterDefine.h"

/**
 模块注册描述
 */
@interface SimpleModuleRegisterDefine : NSObject<WJModuleRegisterDefine>

- (instancetype)initWithModuleClass:(Class)moduleClass;

- (instancetype)initWithModuleClass:(Class)moduleClass serviceRegisterDefines:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines;

- (instancetype)initWithModuleClass:(Class)moduleClass serviceRegisterDefines:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines aspectClassSet:(NSSet<Class>*)aspectClassSet;

@end
