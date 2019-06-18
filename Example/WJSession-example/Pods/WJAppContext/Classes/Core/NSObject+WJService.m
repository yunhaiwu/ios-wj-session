//
//  NSObject+WJService.m
//  WJAppContext-example
//
//  Created by ada on 2019/3/6.
//  Copyright © 2019年 WJ. All rights reserved.
//

#import "NSObject+WJService.h"
#import "WJAppContextDefines.h"

@implementation NSObject (WJService)

#pragma mark WJService
+ (BOOL)hasSingleton {
    return NO;
}

+ (NSString*)serviceId {
    return NSStringFromClass(self);
}

+ (NSString*)moduleId {
    return WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
}

@end
