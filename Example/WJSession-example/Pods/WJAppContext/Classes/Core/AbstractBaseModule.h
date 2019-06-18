//
//  AbstractBaseModule.h
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
#import "WJServiceRegister.h"
#import "WJAspectRegister.h"

/**
 模块抽象基类
 */
@interface AbstractBaseModule : NSObject<WJModule>

/**
 初始化方法
 */
- (instancetype)initWithServicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister;

@end
