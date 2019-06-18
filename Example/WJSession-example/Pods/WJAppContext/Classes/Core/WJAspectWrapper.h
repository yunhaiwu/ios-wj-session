//
//  WJAspectWrapper.h
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
#import "WJAspect.h"


/**
 切面包装类
 */
@interface WJAspectWrapper : NSObject

@property (nonatomic, strong) id<WJAspect> aspect;

/**
 初始化方法
 */
- (instancetype)initWithAspectClass:(Class)aspectClass;

/**
 所属模块id
 */
- (NSString*)moduleId;

/**
 切面id
 */
- (NSString*)aspectId;

/**
 切入类名列表
 */
- (NSSet<NSString*>*)pointcutClassNames;

/**
 切入方法列表
 */
- (NSSet<NSString*>*)pointcutMethods:(NSString*)className;

@end
