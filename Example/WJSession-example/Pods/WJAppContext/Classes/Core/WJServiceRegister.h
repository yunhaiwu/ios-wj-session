//
//  WJServiceRegister.h
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

@protocol WJServiceRegister <NSObject>

/**
 注册服务
 */
- (NSDictionary<NSString*, NSSet<NSString*>*>*)registerService:(Protocol*) serviceProtocol serviceClass:(Class) serviceClass;

/**
 批量注册服务
 */
- (NSDictionary<NSString*, NSSet<NSString*>*>*)batchRegisterServices:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines;

/**
 移除服务列表
 */
- (void)removeServices:(NSDictionary<NSString *, NSSet<NSString*>*>*) serviceIdsMap;

@end
