//
//  AbstractWJAspect.m
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

#import "AbstractWJAspect.h"

@interface AbstractWJAspect ()

@property (nonatomic, assign) NSUInteger options;

@end

@implementation AbstractWJAspect

-(instancetype)init {
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(doBefore:)]) {
            self.options |= WJAopAspectActionOptionBefore;
        }
        if ([self respondsToSelector:@selector(doAfter:)]) {
            self.options |= WJAopAspectActionOptionAfter;
        }
        if ([self respondsToSelector:@selector(doAround:)]) {
            self.options |= WJAopAspectActionOptionAround;
        }
    }
    return self;
}

-(NSString*)pointcutExpressions {
    return nil;
}

-(NSUInteger)aspectActionOption {
    return _options;
}

+ (NSString *)moduleId {
    return WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
}

+ (NSString*)aspectId {
    return NSStringFromClass(self);
}

@end
