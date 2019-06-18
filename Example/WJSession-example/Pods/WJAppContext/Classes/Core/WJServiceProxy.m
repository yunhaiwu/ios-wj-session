//
//  WJServiceProxy.m
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

#import "WJServiceProxy.h"
#import "SimpleAspectJoinPoint.h"

@interface WJServiceProxy ()

@property (nonatomic, strong) NSObject *target;

@property (nonatomic, copy) NSDictionary<NSString*, NSSet<WJAspectWrapper*>*> *methodToAspects;

@end

@implementation WJServiceProxy

+ (instancetype)instanceProxy:(id)target aspectFetcher:(NSDictionary<NSString*, NSSet<WJAspectWrapper*>*>*)methodToAspects {
    WJServiceProxy *serviceProxy = [WJServiceProxy alloc];
    [serviceProxy setTarget:target];
    [serviceProxy setMethodToAspects:methodToAspects];
    return serviceProxy;
    
}

- (Class)class {
    if (_target) {
        return [_target class];
    }
    return [super class];
}

- (Class)superclass {
    if (_target) {
        return [_target superclass];
    }
    return [super class];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *result = nil;
    if (self.target) {
        result = [self.target methodSignatureForSelector:sel];
    } else {
        result = [super methodSignatureForSelector:sel];
    }
    return result;
}

- (NSSet<WJAspectWrapper*>*)getAspectsBySelector:(SEL)selector {
    NSMutableSet<WJAspectWrapper*> *result = [[NSMutableSet alloc] init];
    NSSet<WJAspectWrapper*> *methodAspects = self.methodToAspects[NSStringFromSelector(selector)];
    if (methodAspects) {
        [result addObjectsFromArray:[methodAspects allObjects]];
    }
    NSSet<WJAspectWrapper*> *generalAspects = self.methodToAspects[@"*"];
    if (generalAspects) {
        [result addObjectsFromArray:[generalAspects allObjects]];
    }
    return result;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = [invocation selector];
    if ([self.target respondsToSelector:selector]) {
        @autoreleasepool {
            [invocation setTarget:self.target];
            NSSet<WJAspectWrapper*> *aspects = [self getAspectsBySelector:invocation.selector];
            if ([aspects count] > 0) {
                SimpleAspectJoinPoint *joinPoint = [[SimpleAspectJoinPoint alloc] initWithInvocation:invocation];
                for (WJAspectWrapper *aspectWrapper in aspects) {
                    if ([[aspectWrapper aspect] aspectActionOption] & WJAopAspectActionOptionBefore) {
                        [[aspectWrapper aspect] doBefore:joinPoint];
                    }
                }
                for (WJAspectWrapper *aspectWrapper in aspects) {
                    if ([[aspectWrapper aspect] aspectActionOption] & WJAopAspectActionOptionAround) {
                        [[aspectWrapper aspect] doAround:joinPoint];
                    }
                }
                if (![joinPoint isPerformed]) {
                    [invocation invoke];
                }
                for (WJAspectWrapper *aspectWrapper in aspects) {
                    if ([[aspectWrapper aspect] aspectActionOption] & WJAopAspectActionOptionAfter) {
                        [[aspectWrapper aspect] doAfter:joinPoint];
                    }
                }
            } else {
                [invocation invoke];
            }
        }
    }
}

- (BOOL)isProxy {
    return YES;
}

@end
