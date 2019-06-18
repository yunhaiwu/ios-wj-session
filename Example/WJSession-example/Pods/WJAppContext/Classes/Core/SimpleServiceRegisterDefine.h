//
//  SimpleServiceRegisterDefine.h
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
 服务注册描述
 */
@interface SimpleServiceRegisterDefine : NSObject<WJServiceRegisterDefine>

/**
 初始化方法
 */
- (instancetype)initWithProtocol:(Protocol*)serviceProtocol serviceClass:(Class)serviceClass;

/**
 初始化方法
 */
- (instancetype)initWithProtocol:(Protocol*)serviceProtocol serviceClassSet:(NSSet<Class>*)serviceClassSet;


/**
 添加Service Class
 */
- (void)addServiceClass:(Class)serviceClass;

@end
