//
//  WJAspectContainer.h
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
#import "WJModule.h"
#import "WJAspectWrapper.h"
#import "WJAspectRegister.h"
#import "WJAspectFetcher.h"

/**
 切面容器
 */
@interface WJAspectContainer : NSObject<WJAspectRegister, WJAspectFetcher>

@end
