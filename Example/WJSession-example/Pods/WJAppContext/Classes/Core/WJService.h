//
//  WJService.h
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
 服务协议
 */
@protocol WJService<NSObject>


@optional
/**
 服务是否为单利
 注意：如果是单利，并且没有实现方法 shareInstance，则会创建并缓存，如果实现shareInstance方法，拿到对象也会被缓存
 default NO
 @return 服务是否为单利
 */
+ (BOOL)hasSingleton;

/**
 获得单利类
 */
+ (id)shareInstance;

/**
 服务id，default ClassName
 @return 服务id
 */
+ (NSString*)serviceId;

/**
 所属模块Id
 */
+ (NSString*)moduleId;

@end
