//
//  WJServiceWrapper.h
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
 Service包装器（Service定义、service实例构建）
 */
@interface WJServiceWrapper : NSObject

/**
 初始化方法
 */
- (instancetype)initWithServiceClass:(Class)class;

/**
 服务Id
 */
- (NSString*)getServiceId;

/**
 服务对象
 */
- (id)getServiceObject;


/**
 模块Id
 */
- (NSString*)getModuleId;

@end
