//
//  WJAspectFetcher.h
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
#import "WJAspectWrapper.h"

@protocol WJAspectFetcher <NSObject>

/**
 根据类名获取切面列表
 
 @param className 类名
 @return 切面列表（方法名 -> Aspect）
 */
- (NSDictionary<NSString*, NSSet<WJAspectWrapper*>*>*)fetchAspects:(NSString*)className;

@end
