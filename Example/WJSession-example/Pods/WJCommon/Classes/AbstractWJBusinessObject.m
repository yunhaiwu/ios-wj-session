//
//  BaseBusinessObject.m
//
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by Yunhai.Wu on 15/7/29.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import "AbstractWJBusinessObject.h"

@implementation AbstractWJBusinessObject

-(instancetype)init {
    self = [super init];
    if (self) {
        [self wj_registerForKVO];
    }
    return self;
}

-(void)dealloc {
    [self wj_unregisterFromKVO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ business description ...",NSStringFromClass(self.class)];
}

#pragma mark KVO
-(NSKeyValueObservingOptions)wj_observerOptionsForKeypath:(NSString*) keyPath {
    return NSKeyValueObservingOptionNew;
}

- (void)wj_registerForKVO {
    NSArray *keypaths = [self wj_observableKeypaths];
    if (keypaths && keypaths.count > 0) {
        for (NSString *keyPath in keypaths) {
            [self addObserver:self forKeyPath:keyPath options:[self wj_observerOptionsForKeypath:keyPath] context:NULL];
        }
    }
}

- (void)wj_unregisterFromKVO {
    NSArray *keypaths = [self wj_observableKeypaths];
    if (keypaths && keypaths.count > 0) {
        for (NSString *keyPath in keypaths) {
            [self removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (NSArray*)wj_observableKeypaths {
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self wj_changeForKeypath:keyPath change:change];
}

-(void)wj_changeForKeypath:(NSString *)keyPath change:(NSDictionary *)change {}


@end
