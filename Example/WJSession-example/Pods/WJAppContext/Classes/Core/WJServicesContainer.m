//
//  WJServicesContainer.m
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

#import "WJServicesContainer.h"
#import "WJServiceWrapper.h"
#import "SimpleServiceRegisterDefine.h"
#import "WJLoggingAPI.h"
#import "NSObject+WJService.h"

@interface WJServicesContainer ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableDictionary<NSString *, WJServiceWrapper*>*> *servicesData;

@end

@implementation WJServicesContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(1);
        self.servicesData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString*)getServiceId:(Class)serviceClass {
    NSString *serviceId = nil;
    if ([serviceClass respondsToSelector:@selector(serviceId)]) {
        serviceId = [serviceClass serviceId];
    } else {
        serviceId = NSStringFromClass(serviceClass);
    }
    return serviceId;
}

- (NSDictionary<NSString*, NSSet<NSString*>*>*)registerService:(Protocol*) serviceProtocol serviceClass:(Class)serviceClass {
    if (serviceProtocol && serviceClass != Nil) {
        return [self batchRegisterServices:[NSSet setWithObject:[[SimpleServiceRegisterDefine alloc] initWithProtocol:serviceProtocol serviceClass:serviceClass]]];
    }
    return nil;
}

- (NSDictionary<NSString*, NSSet<NSString*>*>*)batchRegisterServices:(NSSet<id<WJServiceRegisterDefine>>*)serviceRegisterDefines {
    NSMutableDictionary<NSString*, NSMutableSet<NSString*>*> *result = [[NSMutableDictionary alloc] init];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    for (id<WJServiceRegisterDefine> serviceDefine in serviceRegisterDefines) {
        NSMutableSet<NSString*> *registerServiceIds = [[NSMutableSet alloc] init];
        Protocol *serviceProtocol = [serviceDefine serviceProtocol];
        NSSet<Class> *serviceClassSet = [serviceDefine serviceClassSet];
        NSString *protocolName = NSStringFromProtocol(serviceProtocol);
        Class serviceClass = Nil;
        NSEnumerator *enumerator = [serviceClassSet objectEnumerator];
        while (serviceClass = [enumerator nextObject]) {
            if ([serviceClass conformsToProtocol:serviceProtocol]) {
                NSString *serviceId = [self getServiceId:serviceClass];
                NSMutableDictionary *servicesDict = self.servicesData[protocolName];
                if (!servicesDict) {
                    servicesDict = [[NSMutableDictionary alloc] init];
                    [self.servicesData setObject:servicesDict forKey:protocolName];
                }
                [servicesDict setObject:[[WJServiceWrapper alloc] initWithServiceClass:serviceClass] forKey:serviceId];
                [registerServiceIds addObject:serviceId];
                WJLogDebug(@"✅ SERVICES: REGISTER SUCCESSFUL '%@' ~", protocolName);
            } else {
                WJLogDebug(@"❌ SERVICES: CLASS '%@' NOT IMPLEMENTATION PROTOCOL ~ '%@'", NSStringFromClass(serviceClass), protocolName);
            }
        }
        if ([registerServiceIds count] > 0) {
            [result setObject:registerServiceIds forKey:protocolName];
        }
    }
    dispatch_semaphore_signal(self.semaphore);
    return result;
}

- (id)createService:(Protocol*) serviceProtocol serviceId:(NSString*)serviceId {
    if (serviceProtocol) {
        return [self createServiceByProtocolName:NSStringFromProtocol(serviceProtocol) serviceId:serviceId];
    }
    return nil;
}

- (id)createService:(Protocol*) serviceProtocol {
    if (serviceProtocol) {
        return [self createServiceByProtocolName:NSStringFromProtocol(serviceProtocol)];
    }
    return nil;
}

- (id)createServiceByProtocolName:(NSString*) serviceProtocol serviceId:(NSString*) serviceId {
    id service = nil;
    if (serviceProtocol) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSMutableDictionary<NSString*, WJServiceWrapper*> *serviceDict = self.servicesData[serviceProtocol];
        if (serviceDict) {
            if (serviceId) {
                service = [serviceDict[serviceId] getServiceObject];
            } else {
                service = [[[serviceDict allValues] firstObject] getServiceObject];
            }
        }
        dispatch_semaphore_signal(self.semaphore);
    }
    if (!service) {
        WJLogDebug(@"❌ SERVICE: COULD NOT FIND '%@' SERVICE ~", serviceProtocol);
    }
    return service;
}

- (id)createServiceByProtocolName:(NSString*) serviceProtocol {
    return [self createServiceByProtocolName:serviceProtocol serviceId:nil];
}

- (id)createServiceById:(NSString *)serviceId {
    return [self createService:@protocol(WJService) serviceId:serviceId];
}

- (void)removeServices:(NSDictionary<NSString *, NSSet<NSString*>*>*) serviceIdsMap {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSArray *keys = [serviceIdsMap allKeys];
    for (NSString *key in keys) {
        NSSet *serviceIds = serviceIdsMap[key];
        NSMutableDictionary *servicesDict = self.servicesData[key];
        [servicesDict removeObjectsForKeys:[serviceIds allObjects]];
        if ([servicesDict count] == 0) [self.servicesData removeObjectForKey:key];
    }
    dispatch_semaphore_signal(self.semaphore);
    WJLogDebug(@"✅ SERVICES: UNREGISTER SUCCESSFUL '%@' ~", serviceIdsMap);
}

@end
