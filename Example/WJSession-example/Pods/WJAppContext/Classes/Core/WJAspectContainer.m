//
//  WJAspectContainer.m
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

#import "WJAspectContainer.h"
#import "WJConfig.h"
#import "WJLoggingAPI.h"

@interface WJAspectContainer ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, WJAspectWrapper*> *aspectIdToAspect;

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableSet<WJAspectWrapper*>*> *pointcutClassNameToAspectSet;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation WJAspectContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(1);
        self.aspectIdToAspect = [[NSMutableDictionary alloc] init];
        self.pointcutClassNameToAspectSet = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark WJAspectFetcher
- (NSDictionary<NSString*, NSSet<WJAspectWrapper*>*>*)fetchAspects:(NSString*)className {
    NSMutableSet<WJAspectWrapper*> *classAspects = nil;
    NSMutableSet<WJAspectWrapper*> *generalAspects = nil;
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    classAspects = self.pointcutClassNameToAspectSet[className];
    generalAspects = self.pointcutClassNameToAspectSet[@"*"];
    dispatch_semaphore_signal(self.semaphore);
    NSMutableDictionary<NSString*, NSMutableSet<WJAspectWrapper*>*> *methodToAspects = [[NSMutableDictionary alloc] init];
    if ([classAspects count] > 0) {
        for (WJAspectWrapper *a in classAspects) {
            NSSet<NSString*> *methods = [a pointcutMethods:className];
            for (NSString *m in methods) {
                NSMutableSet *s = [methodToAspects objectForKey:m];
                if (!s) {
                    s = [[NSMutableSet alloc] init];
                    [methodToAspects setObject:s forKey:m];
                }
                [s addObject:a];
            }
        }
    }
    if ([generalAspects count] > 0) {
        for (WJAspectWrapper *a in generalAspects) {
            NSSet<NSString*> *methods = [a pointcutMethods:className];
            for (NSString *m in methods) {
                NSMutableSet *s = [methodToAspects objectForKey:m];
                if (!s) {
                    s = [[NSMutableSet alloc] init];
                    [methodToAspects setObject:s forKey:m];
                }
                [s addObject:a];
            }
        }
    }
    return methodToAspects;
}

#pragma mark WJAspectRegister
- (NSSet<NSString*>*)registerAspect:(Class)aspect {
    return [self batchRegisterAspects:[NSSet setWithObject:aspect]];
}

- (NSSet<NSString *> *)batchRegisterAspects:(NSSet<Class> *)aspectClassSet {
    NSMutableSet *result = [[NSMutableSet alloc] init];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    for (Class cls in aspectClassSet) {
        if ([cls conformsToProtocol:@protocol(WJAspect)]) {
            WJAspectWrapper *aspect = [[WJAspectWrapper alloc] initWithAspectClass:cls];
            NSString *aspectId = [aspect aspectId];
            if ([self aspectIdToAspect][aspectId]) {
                WJLogDebug(@"❌ ASPECT: REGISTER FAIL '%@' ~", NSStringFromClass(cls));
            } else {
                NSSet<NSString*> *pointcutClassNames = [aspect pointcutClassNames];
                if ([pointcutClassNames count] > 0) {
                    [self.aspectIdToAspect setObject:aspect forKey:aspectId];
                    [result addObject:aspectId];
                    for (NSString *pointcut in pointcutClassNames) {
                        NSMutableSet<WJAspectWrapper*> *set = self.pointcutClassNameToAspectSet[pointcut];
                        if (!set) {
                            set = [[NSMutableSet alloc] init];
                            [self.pointcutClassNameToAspectSet setObject:set forKey:pointcut];
                        }
                        [set addObject:aspect];
                    }
                    WJLogDebug(@"✅ ASPECT: REGISTER SUCCESSFUL '%@', ~", NSStringFromClass(cls));
                }
            }
        }
    }
    dispatch_semaphore_signal(self.semaphore);
    return result;
}

- (void)removeAspectsByIds:(NSSet<NSString*>*)aspectIds {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    for (NSString *aspectId in aspectIds) {
        WJAspectWrapper *aspect = self.aspectIdToAspect[aspectId];
        NSSet<NSString*> *pointcutClassNames = [aspect pointcutClassNames];
        for (NSString *clsName in pointcutClassNames) {
            NSMutableSet<WJAspectWrapper*> *set = self.pointcutClassNameToAspectSet[clsName];
            [set removeObject:aspect];
            if ([set count] == 0) [self.pointcutClassNameToAspectSet removeObjectForKey:clsName];
        }
        [self.aspectIdToAspect removeObjectForKey:aspectId];
        WJLogDebug(@"✅ ASPECT: UNREGISTER SUCCESSFUL '%@' ~", aspectId);
    }
    dispatch_semaphore_signal(self.semaphore);
}

@end
