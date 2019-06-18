//
//  WJAspectRegister.h
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
 切面注册
 */
@protocol WJAspectRegister <NSObject>

/**
 注册切面
 */
- (NSSet<NSString*>*)registerAspect:(Class)aspect;

/**
 注册切面
 */
- (NSSet<NSString*>*)batchRegisterAspects:(NSSet<Class>*)aspects;

/**
 根据id列表移除切面
 */
- (void)removeAspectsByIds:(NSSet<NSString*>*)aspectIds;


@end
