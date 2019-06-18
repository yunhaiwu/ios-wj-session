//
//  SimpleServiceRegisterDefine.m
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

#import "SimpleServiceRegisterDefine.h"

@interface SimpleServiceRegisterDefine ()

/**
 服务协议
 */
@property (nonatomic, assign) Protocol *serviceProtocol;

/**
 服务列表，所有元素Class都实现了protocol协议
 */
@property(nonatomic, strong) NSMutableSet<Class> *serviceClassSet;

@end

@implementation SimpleServiceRegisterDefine

- (instancetype)initWithProtocol:(Protocol *)serviceProtocol serviceClass:(Class)serviceClass {
    self = [super init];
    if (self) {
        self.serviceProtocol = serviceProtocol;
        self.serviceClassSet = [[NSMutableSet alloc] initWithObjects:serviceClass, nil];
    }
    return self;
}

- (instancetype)initWithProtocol:(Protocol *)serviceProtocol serviceClassSet:(NSSet<Class> *)serviceClassSet {
    self = [super init];
    if (self) {
        self.serviceProtocol = serviceProtocol;
        self.serviceClassSet = [[NSMutableSet alloc] initWithSet:serviceClassSet];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self.class == [object class]) {
        if ([self serviceProtocol] == [object serviceProtocol]) {
            return YES;
        }
    }
    return NO;
    
}

- (NSUInteger)hash {
    return [NSStringFromProtocol(_serviceProtocol) hash];
}

- (void)addServiceClass:(Class)serviceClass {
    if (serviceClass) [_serviceClassSet addObject:serviceClass];
}

#pragma mark WJServiceRegisterDefine
- (Protocol*)serviceProtocol {
    return _serviceProtocol;
}

- (NSSet<Class>*)serviceClassSet {
    return _serviceClassSet;
}

@end
