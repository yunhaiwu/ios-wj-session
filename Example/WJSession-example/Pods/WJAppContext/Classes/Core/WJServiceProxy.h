//
//  WJServiceProxy.h
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

/**
 服务代理
 */
@interface WJServiceProxy : NSProxy

+ (instancetype)instanceProxy:(id)target aspectFetcher:(NSDictionary<NSString*, NSSet<WJAspectWrapper*>*>*)methodToAspects;

@end
