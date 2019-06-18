//
//  WJAppContextPreloadDatas.m
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

#import "WJAppContextPreloadDatas.h"
#import "WJAnnotation.h"
#import "WJAspect.h"
#import "SimpleServiceRegisterDefine.h"
#import "WJConfig.h"
#import "WJLoggingAPI.h"
#import "WJModule.h"

@interface WJAppContextPreloadDatas ()

//切面列表
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableSet<Class>*> *aspectClasses;

//模块列表
@property (nonatomic, strong) NSMutableSet<Class> *moduleClasses;

//服务列表
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableDictionary<NSString*, SimpleServiceRegisterDefine*>*> *serviceDefines;

@end

@implementation WJAppContextPreloadDatas

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WJAppContextPreloadDatas *singletonInstance;
    dispatch_once( &once, ^{
        singletonInstance = [[self alloc] init];
        [singletonInstance singleInit];
    });
    return singletonInstance;
}

- (void)singleInit {
    self.aspectClasses = [[NSMutableDictionary alloc] init];
    self.moduleClasses = [[NSMutableSet alloc] init];
    self.serviceDefines = [[NSMutableDictionary alloc] init];
    [self loadAnnotationPreloadDatas];
    [self loadConfigFilePreloadDatas];
    WJLogDebug(@"✅ PRELOAD DATA READY ...");
}

- (void)loadConfigFilePreloadDatas {
    NSDictionary *config = [WJConfig dictionaryForKey:WJ_APP_CONTEXT_CONFIG_KEY];
    NSArray *configModuleDefines = config[@"modules"];
    if ([configModuleDefines count] > 0) {
        for (NSString *modClassName in configModuleDefines) {
            Class clazz = NSClassFromString(modClassName);
            if ([clazz conformsToProtocol:@protocol(WJModule)]) {
                [self.moduleClasses addObject:clazz];
            }
        }
    }
    
    NSDictionary *configServiceDefines = config[@"services"];
    NSArray *serviceProtocolList = [configServiceDefines allKeys];
    for (NSString *serviceProtocolName in serviceProtocolList) {
        Protocol *protocol = NSProtocolFromString(serviceProtocolName);
        if (protocol) {
            NSArray *serviceClassNames = configServiceDefines[serviceProtocolName];
            for (NSString *serviceClassName in serviceClassNames) {
                Class serviceClass = NSClassFromString(serviceClassName);
                NSString *moduleId = nil;
                if ([serviceClass conformsToProtocol:protocol]) {
                    if ([serviceClass respondsToSelector:@selector(moduleId)]) {
                        moduleId = [serviceClass moduleId];
                    }
                    if (!moduleId) moduleId = WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
                    NSMutableDictionary<NSString*, SimpleServiceRegisterDefine*> *serviceDefinesDict = self.serviceDefines[moduleId];
                    if (!serviceDefinesDict) {
                        serviceDefinesDict = [[NSMutableDictionary alloc] init];
                        self.serviceDefines[moduleId] = serviceDefinesDict;
                    }
                    SimpleServiceRegisterDefine *serviceRegisterDefine = serviceDefinesDict[serviceProtocolName];
                    if (serviceRegisterDefine) {
                        [serviceRegisterDefine addServiceClass:serviceClass];
                    } else {
                        serviceRegisterDefine = [[SimpleServiceRegisterDefine alloc] initWithProtocol:protocol serviceClass:serviceClass];
                        serviceDefinesDict[serviceProtocolName] = serviceRegisterDefine;
                    }
                }
            }
        }
    }
    
    
    NSArray *configAspectDefines = config[@"aspects"];
    if ([configAspectDefines count] > 0) {
        for (NSString* aspectClassName in configAspectDefines) {
            Class clazz = NSClassFromString(aspectClassName);
            if ([clazz conformsToProtocol:@protocol(WJAspect)]) {
                NSString *moduleId = nil;
                if ([clazz respondsToSelector:@selector(moduleId)]) {
                    moduleId = [clazz moduleId];
                }
                if (!moduleId) moduleId = WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
                NSMutableSet *set = self.aspectClasses[moduleId];
                if (!set) {
                    set = [[NSMutableSet alloc] init];
                    [self.aspectClasses setObject:set forKey:moduleId];
                }
                [set addObject:clazz];
            }
        }
    }
}

- (void)loadAnnotationPreloadDatas {
    
    NSArray *annotationModuleDefines = [WJAnnotation getAnnotationModuleDefines];
    if ([annotationModuleDefines count] > 0) {
        for (NSString *modClassName in annotationModuleDefines) {
            Class clazz = NSClassFromString(modClassName);
            if ([clazz conformsToProtocol:@protocol(WJModule)]) {
                [self.moduleClasses addObject:clazz];
            }
        }
    }
    NSArray *annotationServiceDefines = [WJAnnotation getAnnotationServiceDefines];
    if ([annotationServiceDefines count] > 0) {
        for (NSString *expr in annotationServiceDefines) {
            NSString *moduleId = nil;
            Class serviceClass = nil;
            Protocol *serviceProtocol = nil;
            NSString *serviceProtocolName = nil;
            NSArray *components  = [expr componentsSeparatedByString:@":"];
            
            if ([components count] == 2) {
                serviceProtocolName = components[0];
                serviceProtocol = NSProtocolFromString(serviceProtocolName);
                serviceClass = NSClassFromString(components[1]);
                if ([serviceClass respondsToSelector:@selector(moduleId)]) {
                    moduleId = [serviceClass moduleId];
                }
            }
            if (!moduleId) moduleId = WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
            if ([serviceClass conformsToProtocol:serviceProtocol]) {
                NSMutableDictionary<NSString*, SimpleServiceRegisterDefine*> *serviceDefinesDict = self.serviceDefines[moduleId];
                if (!serviceDefinesDict) {
                    serviceDefinesDict = [[NSMutableDictionary alloc] init];
                    self.serviceDefines[moduleId] = serviceDefinesDict;
                }
                SimpleServiceRegisterDefine *serviceRegisterDefine = serviceDefinesDict[serviceProtocolName];
                if (serviceRegisterDefine) {
                    [serviceRegisterDefine addServiceClass:serviceClass];
                } else {
                    serviceRegisterDefine = [[SimpleServiceRegisterDefine alloc] initWithProtocol:serviceProtocol serviceClass:serviceClass];
                    serviceDefinesDict[serviceProtocolName] = serviceRegisterDefine;
                }
            }
        }
    }
    
    NSArray *annotationAspectDefines = [WJAnnotation getAnnotationAspectDefines];
    if ([annotationAspectDefines count] > 0) {
        for (NSString* aspectClassName in annotationAspectDefines) {
            Class clazz = NSClassFromString(aspectClassName);
            if ([clazz conformsToProtocol:@protocol(WJAspect)]) {
                NSString *moduleId = nil;
                if ([clazz respondsToSelector:@selector(moduleId)]) {
                    moduleId = [clazz moduleId];
                }
                if (!moduleId) moduleId = WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
                NSMutableSet *set = self.aspectClasses[moduleId];
                if (!set) {
                    set = [[NSMutableSet alloc] init];
                    [self.aspectClasses setObject:set forKey:moduleId];
                }
                [set addObject:clazz];
            }
        }
    }
}

- (NSSet<Class>*)getPreloadModules {
    return [_moduleClasses copy];
}

- (NSSet<id<WJServiceRegisterDefine>>*)getPreloadServiceDefinesByModuleId:(NSString*)moduleId {
    if (moduleId) {
        NSArray *a = [(NSDictionary*)[self serviceDefines][moduleId] allValues];
        if ([a count] > 0) {
            return [NSSet setWithArray:a];
        }
    }
    return nil;
}

- (NSSet<Class>*)getPreloadAspectsByModuleId:(NSString*)moduleId {
    return _aspectClasses[moduleId];
}

@end
