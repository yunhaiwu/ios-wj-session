//
//  WJServicesContainer.h
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
#import "WJServiceFetcher.h"
#import "WJServiceRegister.h"

/**
 服务容器，线程安全
 */
@interface WJServicesContainer : NSObject<WJServiceFetcher, WJServiceRegister>

@end
