//
//  SimpleModuleContext.m
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

#import "SimpleModuleContext.h"
#import "WJService.h"
#import "WJLoggingAPI.h"
#import "WJServiceProxy.h"
#import "WJServiceWrapper.h"

@interface SimpleModuleContext ()

@property (nonatomic, strong)  dispatch_semaphore_t semaphore;

@property (nonatomic, copy) NSString *moduleId;

@property (nonatomic, weak) id<WJServiceRegister> servicesRegister;

@property (nonatomic, weak) id<WJAspectRegister> aspectsRegister;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet<NSString*>*> *modServicesMap;

@property (nonatomic, strong) NSMutableSet<NSString*> *aspectIds;

@end

@implementation SimpleModuleContext

- (instancetype)initWithModuleId:(NSString*)moduleId servicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister {
    self = [super init];
    if (self) {
        self.modServicesMap = [[NSMutableDictionary alloc] init];
        self.aspectIds = [[NSMutableSet alloc] init];
        self.servicesRegister = servicesRegister;
        self.aspectsRegister = aspectsRegister;
        self.moduleId = moduleId;
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (NSString*)moduleId {
    return _moduleId;
}

- (void)handleRegisterServicesResult:(NSDictionary<NSString*, NSSet<NSString*>*>*)registerServicesResult {
    if ([registerServicesResult count] > 0) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSArray *keys = [registerServicesResult allKeys];
        for (NSString *key in keys) {
            NSSet<NSString*>* serviceIds = registerServicesResult[key];
            NSMutableSet<NSString*> *modServiceIds = self.modServicesMap[key];
            if (!modServiceIds) {
                modServiceIds = [[NSMutableSet alloc] init];
                [self.modServicesMap setObject:modServiceIds forKey:key];
            }
            [modServiceIds addObjectsFromArray:[serviceIds allObjects]];
        }
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)handleRegisterAspectsResult:(NSSet<NSString*>*)registerAspectsResult {
    if ([registerAspectsResult count] > 0) {
        [self.aspectIds addObjectsFromArray:registerAspectsResult.allObjects];
    }
}

#pragma mark WJModuleContext
- (void)registerServiceClass:(Class) serviceClass {
    [self registerService:@protocol(WJService) serviceClass:serviceClass];
}

- (void)registerService:(Protocol*) serviceProtocol serviceClass:(Class) serviceClass {
    [self handleRegisterServicesResult:[self.servicesRegister registerService:serviceProtocol serviceClass:serviceClass]];
}

-(void)batchRegisterServices:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines {
    [self handleRegisterServicesResult:[self.servicesRegister batchRegisterServices:serviceRegisterDefines]];
}

- (void)registerService:(id<WJServiceRegisterDefine>)serviceRegisterDefine {
    if (serviceRegisterDefine) [self batchRegisterServices:[NSSet setWithObject:serviceRegisterDefine]];
}

- (void)moduleDestroy {
    [self.servicesRegister removeServices:self.modServicesMap];
    [self.aspectsRegister removeAspectsByIds:self.aspectIds];
}

- (void)registerAspect:(Class)aspectClass {
    [self handleRegisterAspectsResult:[self.aspectsRegister registerAspect:aspectClass]];
}

- (void)batchRegisterAspects:(NSSet<Class>*)aspects {
    [self handleRegisterAspectsResult:[self.aspectsRegister batchRegisterAspects:aspects]];
}

@end
