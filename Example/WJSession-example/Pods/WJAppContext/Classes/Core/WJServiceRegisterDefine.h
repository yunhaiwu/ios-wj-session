//
//  WJServiceRegisterDefine.h
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

/**
 服务注册描述协议
 */
@protocol WJServiceRegisterDefine <NSObject>

/**
 服务协议
 */
- (Protocol*)serviceProtocol;

/**
 服务列表
 */
- (NSSet<Class>*)serviceClassSet;

@end
