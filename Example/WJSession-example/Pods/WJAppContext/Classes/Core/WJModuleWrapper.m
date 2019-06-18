//
//  WJModuleWrapper.m
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

#import "WJModuleWrapper.h"
#import "AbstractBaseModule.h"

@interface WJModuleWrapper ()

@property (nonatomic, assign) Class modClass;

@property (nonatomic, copy) NSString *moduleId;

@property (nonatomic, assign) int modPriority;

@property (nonatomic, strong) id<WJModule> module;

@property (nonatomic, weak) id<WJServiceRegister> servicesRegister;

@property (nonatomic, weak) id<WJAspectRegister> aspectsRegister;

@end

@implementation WJModuleWrapper

- (instancetype)initWithModuleClass:(Class)modClass servicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister {
    self = [super init];
    if (self) {
        self.servicesRegister = servicesRegister;
        self.aspectsRegister = aspectsRegister;
        self.modClass = modClass;
        self.modPriority = [self.modClass modPriority];
        self.moduleId = [self.modClass moduleId];
    }
    return self;
}

- (id<WJModule>)getModuleObject {
    return _module;
}

- (NSString*)moduleId {
    return _moduleId;
}

- (int)modulePriority {
    return _modPriority;
}

- (void)triggerModuleInitAction {
    if (!_module) {
        self.module = [[_modClass alloc] initWithServicesRegister:_servicesRegister aspectsRegister:_aspectsRegister];
        [self changeModStatus:WJModuleStatusInitialized];
        [self.module onModuleInit:self.module.modContext];
    }
}

- (void)changeModStatus:(WJModuleStatus)status {
    if (_modStatus < status) {
        [self willChangeValueForKey:@"modStatus"];
        _modStatus = status;
        [self didChangeValueForKey:@"modStatus"];
    }
}

- (void)triggerModuleDestroyAction:(void (^)(id<WJModule> mod))actionBlock {
    [self.module onModuleWillDestroy:self.module.modContext];
    if (NULL != actionBlock) {
        actionBlock(self.module);
    }
    [[self.module modContext] moduleDestroy];
    [self.module onModuleDidDestroy:self.module.modContext];
    [self changeModStatus:WJModuleStatusDestroyed];
}

- (void)triggerModuleLoadingAction:(void (^)(id<WJModule> mod))actionBlock {
    [self changeModStatus:WJModuleStatusLoading];
    [self.module onModuleWillLoad:self.module.modContext];
    if (NULL != actionBlock) {
        actionBlock(self.module);
    }
    [self.module onModuleDidLoad:self.module.modContext];
    [self changeModStatus:WJModuleStatusLoaded];
}

- (void)triggerOtherModulesDestroyAction:(NSString*)destModId {
    if ([self.module respondsToSelector:@selector(onModuleDidOtherModuleDestroyNotify:)]) {
        [self.module onModuleDidOtherModuleDestroyNotify:destModId];
    }
}

@end
