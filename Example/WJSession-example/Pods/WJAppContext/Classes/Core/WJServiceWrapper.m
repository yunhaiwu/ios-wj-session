//
//  WJServiceWrapper.m
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

#import "WJServiceWrapper.h"
#import "NSObject+WJService.h"
#import "WJAppContextDefines.h"

@interface WJServiceWrapper ()

@property (nonatomic, assign) Class serviceClass;

@property (nonatomic, strong) id singletonServiceObject;

@property (nonatomic, assign) BOOL hasSingleton;

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *moduleId;

@end

@implementation WJServiceWrapper

- (instancetype)initWithServiceClass:(Class)class {
    if (self = [super init]) {
        self.serviceClass = class;
        self.serviceId = [self.serviceClass serviceId];
        self.moduleId = [self.serviceClass moduleId];
        if (!_moduleId) self.moduleId = WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
        if (!_serviceId) self.serviceId = NSStringFromClass(class);
        if ([self.serviceClass respondsToSelector:@selector(hasSingleton)]) {
            _hasSingleton = [self.serviceClass hasSingleton];
        }
    }
    return self;
}

- (NSString *)getServiceId {
    return _serviceId;
}

- (id)getServiceObject {
    id serviceObject = self.singletonServiceObject;
    if (!serviceObject && self.serviceClass) {
        if (_hasSingleton) {
            @synchronized (self) {
                if (!_singletonServiceObject) {
                    if ([self.serviceClass respondsToSelector:@selector(shareInstance)]) {
                        self.singletonServiceObject = [self.serviceClass shareInstance];
                    }
                    if (!self.singletonServiceObject) {
                        self.singletonServiceObject = [[self.serviceClass alloc] init];
                    }
                }
                serviceObject = self.singletonServiceObject;
            }
        } else {
            serviceObject = [[self.serviceClass alloc] init];
        }
    }
    return serviceObject;
}

- (NSString *)getModuleId {
    return _moduleId;
}

@end
