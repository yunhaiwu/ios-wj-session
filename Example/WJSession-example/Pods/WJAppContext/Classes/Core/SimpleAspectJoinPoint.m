//
//  SimpleAspectJoinPoint.m
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

#import "SimpleAspectJoinPoint.h"

@interface SimpleAspectJoinPoint ()

@property (nonatomic, strong) NSInvocation *invocation;

@property (nonatomic, assign) BOOL performed;

@end

@implementation SimpleAspectJoinPoint

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    self = [super init];
    if (self) {
        self.invocation = invocation;
    }
    return self;
}

- (NSInvocation*)getInvocation {
    return _invocation;
}

#pragma mark WJJoinPoint
- (SEL)aopSelector {
    return [_invocation selector];
}

- (id)aopTarget {
    return [_invocation target];
}

- (NSUInteger)numberOfArguments {
    return [[_invocation methodSignature] numberOfArguments];
}

- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    [_invocation getArgument:argumentLocation atIndex:idx];
}

- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx {
    [_invocation setArgument:argumentLocation atIndex:idx];
}

- (BOOL)isPerformed {
    return _performed;
}

- (void)proceed {
    if (!_performed) {
        _performed = YES;
        [[self getInvocation] invoke];
    }
}

@end
