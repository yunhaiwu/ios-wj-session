//
//  WJModuleContainer.m
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

#import "WJModuleContainer.h"
#import "WJLoggingAPI.h"
#import "SimpleModuleRegisterDefine.h"
#import "WJAppContextDefines.h"
#import "WJModuleWrapper.h"


@interface WJModuleContainer ()

@property (nonatomic, strong) NSMutableArray<WJModuleWrapper*> *modules;

@property (nonatomic, strong) NSMutableDictionary<NSString*, WJModuleWrapper*> *modulesMap;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, weak) id<WJServiceRegister> servicesRegister;

@property (nonatomic, weak) id<WJAspectRegister> aspectsRegister;

@property (atomic, assign) BOOL modulesInitialized;

@property (nonatomic, strong) NSMutableSet<id<WJModuleRegisterDefine>> *moduleRegisterDefines;

@end

@implementation WJModuleContainer

- (instancetype)initWithServicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister {
    self = [super init];
    if (self) {
        self.moduleRegisterDefines = [[NSMutableSet alloc] init];
        self.servicesRegister = servicesRegister;
        self.aspectsRegister = aspectsRegister;
        self.semaphore = dispatch_semaphore_create(1);
        self.modulesMap = [[NSMutableDictionary alloc] init];
        self.modules = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)unRegisterModule:(Class)modClass {
    NSString *moduleId = [modClass moduleId];
    if ([moduleId isEqualToString:WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID]) {
        WJLogWarn(@"⚠️ MODULE: Illegal UNREGISTER MODULE '%@' ~", moduleId);
    } else {
        WJModuleWrapper *modWrapper = self.modulesMap[moduleId];
        if (modWrapper) {
            id<WJModule> mod = [modWrapper getModuleObject];
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            [modWrapper triggerModuleDestroyAction:^(id<WJModule> module) {
                [self.modulesMap removeObjectForKey:moduleId];
                [self.modules removeObject:modWrapper];
            }];
            WJLogDebug(@"✅ MODULE: UNREGISTER SUCCESSFUL '%@' ~ ",  moduleId);
            dispatch_semaphore_signal(self.semaphore);
            [self triggerOtherModulesDestroyEvent:[mod modContext].moduleId];
        }
    }
}

- (id<WJModule>)getModuleById:(NSString *)moduleId {
    return [(WJModuleWrapper*)_modulesMap[moduleId] getModuleObject];
}

- (id<WJModule>)globalDefaultModule {
    return [self getModuleById:WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID];
}

- (void)triggerOtherModulesDestroyEvent:(NSString*)moduleId {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *mods = [self.modules copy];
        NSInteger count = [mods count];
        for (NSInteger i = 0; i < count; i++) {
            WJModuleWrapper *modWrapper = mods[i];
            if (![[modWrapper moduleId] isEqualToString:moduleId]) {
                [modWrapper triggerOtherModulesDestroyAction:moduleId];
            }
        }
    });
}

- (BOOL)isExistModule:(Class)modClass {
    NSString *moduleId = [modClass moduleId];
    if (_modulesMap[moduleId]) {
        return YES;
    }
    return NO;
}

- (void)performModulesInit {
    if (!_modulesInitialized) {
        _modulesInitialized = YES;
        NSArray *modRegisterDefines = [[self.moduleRegisterDefines allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            int mod1Priority = [[(id<WJModuleRegisterDefine>)obj1 moduleClass] modPriority];
            int mod2Priority = [[(id<WJModuleRegisterDefine>)obj2 moduleClass] modPriority];
            if (mod1Priority > mod2Priority) {
                return NSOrderedAscending;
            } else if (mod1Priority < mod2Priority) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        NSUInteger count = [modRegisterDefines count];
        for (NSUInteger i = 0; i < count; i++) {
            [self registerModuleByDefine:modRegisterDefines[i]];
        }
        self.moduleRegisterDefines = nil;
    }
}

#pragma mark WJModuleRegister
- (void)registerModule:(Class)moduleClass {
    [self registerModuleByDefine:[[SimpleModuleRegisterDefine alloc] initWithModuleClass:moduleClass]];
}

- (void)registerModuleByDefine:(id<WJModuleRegisterDefine>)moduleRegisterDefine {
    if (_modulesInitialized) {
        if ([[moduleRegisterDefine moduleClass] conformsToProtocol:@protocol(WJModule)]) {
            if ([self isExistModule:[moduleRegisterDefine moduleClass]]) {
                WJLogError(@"❌ MODULE: REGISTER FAIL (EXIST) '%@' ~ ",  NSStringFromClass([moduleRegisterDefine moduleClass]));
            } else {
                WJModuleWrapper *modWrapper = [[WJModuleWrapper alloc] initWithModuleClass:[moduleRegisterDefine moduleClass] servicesRegister:_servicesRegister aspectsRegister:_aspectsRegister];
                [modWrapper triggerModuleInitAction];
                [modWrapper triggerModuleLoadingAction:^(id<WJModule> module) {
                    if ([[moduleRegisterDefine aspectClassSet] count] > 0) {
                        [[module modContext] batchRegisterAspects:[moduleRegisterDefine aspectClassSet]];
                    }
                    if ([[moduleRegisterDefine serviceRegisterDefines] count] > 0) {
                        [[module modContext] batchRegisterServices:[moduleRegisterDefine serviceRegisterDefines]];
                    }
                }];
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                [self.modules addObject:modWrapper];
                [self.modules sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    WJModuleWrapper *mod1 = (WJModuleWrapper*)obj1;
                    WJModuleWrapper *mod2 = (WJModuleWrapper*)obj2;
                    if ([mod1 modulePriority] > [mod2 modulePriority]) {
                        return NSOrderedAscending;
                    } else if ([mod1 modulePriority] < [mod2 modulePriority]) {
                        return NSOrderedDescending;
                    }
                    return NSOrderedSame;
                }];
                self.modulesMap[[modWrapper moduleId]] = modWrapper;
                dispatch_semaphore_signal(self.semaphore);
                WJLogDebug(@"✅ MODULE: REGISTER SUCCESSFUL '%@' ~ ",  [modWrapper moduleId]);
            }
        } else {
            WJLogError(@"❌ MODULE: '%@' REGISTER MODULE FAIL (NOT IMPLEMENTATION PROTOCOL 'IWJMODULE') ~ ",  NSStringFromClass([moduleRegisterDefine moduleClass]));
        }
    } else {
        [self.moduleRegisterDefines addObject:moduleRegisterDefine];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self performModulesInit];
    NSArray *mods = [_modules copy];
    NSInteger count = [mods count];
    for (NSInteger i = 0; i < count; i++) {
        id<WJModule> mod = [(WJModuleWrapper*)mods[i] getModuleObject];
        if ([mod respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [mod application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }
    return YES;
}

#pragma mark forwarding
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSArray *mods = [_modules copy];
    NSInteger count = [mods count];
    for (NSInteger i = 0; i < count; i++) {
        id<WJModule> mod = [(WJModuleWrapper*)mods[i] getModuleObject];
        if ([mod respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:mod];
        }
    }
}

@end
