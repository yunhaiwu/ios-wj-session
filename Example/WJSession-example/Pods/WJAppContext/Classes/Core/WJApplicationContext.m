//
//  WJAppContext.m
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

#import "WJApplicationContext.h"
#import "WJModule.h"
#import "WJConfig.h"
#import "WJModuleContainer.h"
#import "WJServicesContainer.h"
#import "WJLoggingAPI.h"
#import "WJAspectContainer.h"
#import "WJServiceProxy.h"
#import "WJAppContextPreloadDatas.h"
#import "SimpleModuleRegisterDefine.h"
#import "WJAppContextPreloadDatas.h"
#import "GlobalDefaultModule.h"
#import "NSObject+WJService.h"

@interface WJApplicationContext ()

@property (nonatomic, strong) WJModuleContainer *modContainer;
@property (nonatomic, strong) WJServicesContainer *serviceContainer;
@property (nonatomic, strong) WJAspectContainer *aspectContainer;

@end

@implementation WJApplicationContext

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WJApplicationContext *singletonInstance;
    dispatch_once( &once, ^{
        singletonInstance = [[self alloc] init];
        [singletonInstance singleInit];
    });
    return singletonInstance;
}

- (void)loadGlobalDefaultModule {
    [self registerModule:[GlobalDefaultModule class]];
}

-(void)triggerModuleLoading {
    [self loadGlobalDefaultModule];
    NSSet<Class>* moduleClassSet = [[WJAppContextPreloadDatas sharedInstance] getPreloadModules];
    for (Class modClass in moduleClassSet) {
        [self registerModule:modClass];
    }
}

- (void)singleInit {
    self.serviceContainer = [[WJServicesContainer alloc] init];
    self.aspectContainer = [[WJAspectContainer alloc] init];
    self.modContainer = [[WJModuleContainer alloc] initWithServicesRegister:self.serviceContainer aspectsRegister:self.aspectContainer];
    [self triggerModuleLoading];
}

- (void)registerModule:(Class)moduleClass {
    if (moduleClass) {
        [self registerModules:[NSSet setWithObject:moduleClass]];
    }
}

- (void)registerModules:(NSSet<Class> *)moduleClassSet {
    for (Class modClass in moduleClassSet) {
        NSString *moduleId = [modClass moduleId];
        NSSet<id<WJServiceRegisterDefine>>* serviceDefines = [[WJAppContextPreloadDatas sharedInstance] getPreloadServiceDefinesByModuleId:moduleId];
        NSSet<Class> *aspectDefines = [[WJAppContextPreloadDatas sharedInstance] getPreloadAspectsByModuleId:moduleId];
        SimpleModuleRegisterDefine *modDefine = [[SimpleModuleRegisterDefine alloc] initWithModuleClass:modClass serviceRegisterDefines:serviceDefines aspectClassSet:aspectDefines];
        [_modContainer registerModuleByDefine:modDefine];
    }
}

- (void)unRegisterModule:(Class)moduleClass {
    [_modContainer unRegisterModule:moduleClass];
}

#pragma mark forwarding lifecycle method
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.modContainer;
}

- (void)registerService:(Protocol *)serviceProtocol serviceClass:(Class) serviceClass {
    if (serviceClass && serviceProtocol) {
        [[[_modContainer globalDefaultModule] modContext] registerService:serviceProtocol serviceClass:serviceClass];
    } else {
        WJLogDebug(@"❌ REGISTER SERVICE FAIL ~");
    }
}

- (void)registerService:(Class)serviceClass {
    if (serviceClass) {
        [self.serviceContainer registerService:@protocol(WJService) serviceClass:serviceClass];
    }
}

- (id)createService:(Protocol*)protocol {
    return [self createService:protocol serviceId:nil];
}

- (id)createService:(Protocol *)serviceProtocol serviceId:(NSString *)serviceId {
    id service = [self.serviceContainer createService:serviceProtocol serviceId:serviceId];
    if (service) {
        NSDictionary<NSString*, NSSet<WJAspectWrapper*>*>* methodToAspects = [_aspectContainer fetchAspects:NSStringFromClass([service class])];
        if ([methodToAspects count] > 0) {
            service = [WJServiceProxy instanceProxy:service aspectFetcher:methodToAspects];
        }
    }
    return service;
}

- (id)createServiceByName:(NSString *)serviceProtocolName {
    return [self createServiceByName:serviceProtocolName serviceId:nil];
}

- (id)createServiceByName:(NSString *)serviceProtocolName serviceId:(NSString *)serviceId {
    Protocol *protocol = NSProtocolFromString(serviceProtocolName);
    if (protocol) return [self createService:protocol serviceId:serviceId];
    return nil;
}

- (id)createServiceById:(NSString *)serviceId {
    return [self.serviceContainer createService:@protocol(WJService) serviceId:serviceId];
}


@end
