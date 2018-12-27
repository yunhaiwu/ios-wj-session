//
//  WJCacheConfig.m
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by 吴云海 on 16/9/6.
//  Copyright © 2016年 wuyunhai. All rights reserved.
//

#import "WJCacheConfig.h"
#import "WJCacheFactory.h"
#import "WJConfig.h"

@implementation WJCacheConfig

DEF_SINGLETON_INIT(WJCacheConfig)

-(void) singleInit {
    _keychainDefaultService = [[NSBundle mainBundle] bundleIdentifier];
    _keychainAccessGroup = @"";
    
    NSDictionary *config = [WJConfig dictionaryForKey:@"WJCacheAPI"];
    if ([[config allKeys] containsObject:@"keychainService"]) {
        id o = [config objectForKey:@"keychainService"];
        if ([o isKindOfClass:[NSString class]]) {
            _keychainDefaultService = o;
        }
    }
    if ([[config allKeys] containsObject:@"keychainAccessGroup"]) {
        id o = [config objectForKey:@"keychainAccessGroup"];
        if ([o isKindOfClass:[NSString class]]) {
            _keychainAccessGroup = o;
        }
    }
    if ([[config allKeys] containsObject:@"caches"]) {
        id o = [config objectForKey:@"caches"];
        if ([o isKindOfClass:[NSArray class]]) {
            for (id item in o) {
                if ([item isKindOfClass:[NSString class]]) {
                    [self saveCacheObjectClass:NSClassFromString(item)];
                }
            }
        }
    }
}

-(void) setKeychainAccessGroup:(NSString*) keychainAccessGroup {
    _keychainAccessGroup = [keychainAccessGroup copy];
}

-(void) setKeychainDefaultService:(NSString *) defaultService {
    if (defaultService) {
        _keychainDefaultService = [defaultService copy];
    }
}

- (BOOL)saveCacheObjectClass:(Class)cacheClass {
    return [WJCacheFactory injectCacheClass:cacheClass];
}

@end
