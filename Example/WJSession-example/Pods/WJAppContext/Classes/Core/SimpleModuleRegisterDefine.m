//
//  SimpleModuleRegisterDefine.m
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

#import "SimpleModuleRegisterDefine.h"

@interface SimpleModuleRegisterDefine ()

@property (nonatomic, assign) Class moduleClass;

@property (nonatomic, copy) NSSet<id<WJServiceRegisterDefine>> *serviceRegisterDefines;

@property (nonatomic, copy) NSSet<Class> *aspectClassSet;

@end

@implementation SimpleModuleRegisterDefine

- (instancetype)initWithModuleClass:(Class)moduleClass {
    self = [super init];
    if (self) {
        self.moduleClass = moduleClass;
    }
    return self;
}

- (instancetype)initWithModuleClass:(Class)moduleClass serviceRegisterDefines:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines {
    self = [super init];
    if (self) {
        self.moduleClass = moduleClass;
        self.serviceRegisterDefines = serviceRegisterDefines;
    }
    return self;
}

- (instancetype)initWithModuleClass:(Class)moduleClass serviceRegisterDefines:(NSSet<id<WJServiceRegisterDefine>> *)serviceRegisterDefines aspectClassSet:(NSSet<Class> *)aspectClassSet {
    self = [super init];
    if (self) {
        self.moduleClass = moduleClass;
        self.serviceRegisterDefines = serviceRegisterDefines;
        self.aspectClassSet = aspectClassSet;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self.class == [object class]) {
        if (self.moduleClass == [object moduleClass]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [self.moduleClass hash];
}

#pragma mark WJModuleRegisterDefine
- (Class)moduleClass {
    return _moduleClass;
}

- (NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines {
    return _serviceRegisterDefines;
}

- (NSSet<Class>*)aspectClassSet; {
    return _aspectClassSet;
}

@end
