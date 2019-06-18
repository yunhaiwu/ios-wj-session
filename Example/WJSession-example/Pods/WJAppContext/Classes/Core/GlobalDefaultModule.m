//
//  GlobalDefaultModule.m
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

#import "GlobalDefaultModule.h"


@implementation GlobalDefaultModule

+ (int)modPriority {
    return WJ_MODULE_LOADING_PRIORITY_HIGH + 1;
}

+ (NSString *)moduleId {
    return WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
}

@end
