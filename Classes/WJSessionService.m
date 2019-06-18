//
//  WJSessionService.m
//
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by Yunhai.Wu on 15/11/2.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import "WJSessionService.h"
#import "WJCacheAPI.h"
#import "IWJTokenSerializerService.h"
#import "WJLoggingAPI.h"

NSString * const UserLoginedNotification = @"UserLoginedNotification";

NSString * const UserLogoutNotification = @"UserLogoutNotification";

#define WJ_SESSION_KEYCHAIN_STORE_TOKEN_KEY            @"appTokenKey"
#define WJ_SESSION_USERDEFAULTS_STORE_DATA_SAFE_KEY    @"dataSafeKey"

@interface WJSessionService ()
@property (nonatomic, copy) id<IWJToken> token;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) id<IWJCache> keychainCache;
@property (nonatomic, strong) id<IWJCache> userDefaultsCache;
@property (nonatomic, strong) id<IWJTokenSerializerService> tokenSerializerService;
@property(nonatomic) dispatch_queue_t storage_queue;
@end

@implementation WJSessionService



-(void) deleteStorage {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_storage_queue, ^{
        [weakSelf.keychainCache removeObjectForKey:WJ_SESSION_KEYCHAIN_STORE_TOKEN_KEY];
        [weakSelf.userDefaultsCache removeObjectForKey:WJ_SESSION_USERDEFAULTS_STORE_DATA_SAFE_KEY];
    });
}

-(void) syncStorage {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_storage_queue, ^{
        if (weakSelf.token) {
            NSData *tokenData = [self.tokenSerializerService serialization:weakSelf.token];
            if (tokenData) [weakSelf.keychainCache setData:tokenData forKey:WJ_SESSION_KEYCHAIN_STORE_TOKEN_KEY];
            if ([weakSelf.token dataSafeKey]) [weakSelf.userDefaultsCache setString:[weakSelf.token dataSafeKey] forKey:WJ_SESSION_USERDEFAULTS_STORE_DATA_SAFE_KEY];//保存数据安全key到userdefaults
        }
    });
}

-(void) loadStorage {
    if ([self.keychainCache hasObjectForKey:WJ_SESSION_KEYCHAIN_STORE_TOKEN_KEY]) {
        NSData *tokenData = [self.keychainCache dataForKey:WJ_SESSION_KEYCHAIN_STORE_TOKEN_KEY];
        if (tokenData) {
            id<IWJToken> tokenValue = [self.tokenSerializerService deserialization:tokenData];
            NSString *dataSafeKey = [_userDefaultsCache stringForKey:WJ_SESSION_USERDEFAULTS_STORE_DATA_SAFE_KEY];
            if (dataSafeKey && [dataSafeKey isEqualToString:[tokenValue dataSafeKey]]) {
                self.token = tokenValue;
            } else {
                self.token = nil;
                [self deleteStorage];
            }
        }
    }
}

-(void)loadSessionTokenSerializer {
    self.tokenSerializerService = [WJAppContext createService:@protocol(IWJTokenSerializerService)];
    if (!self.tokenSerializerService) {
        @throw [[NSException alloc] initWithName:@"WJSessionServiceException" reason:@"没有找到IWJTokenSerializerService服务" userInfo:nil];
    }
}

/**
 *  初始化方法
 */
-(void) singleInit {
    _storage_queue = dispatch_queue_create("wj_session_storage_queue", DISPATCH_QUEUE_SERIAL);
    if (WJ_CACHE_IS_VALID(WJCacheTypeKeychain)) {
        self.keychainCache = WJ_CACHE_OBJECT(WJCacheTypeKeychain);
    } else {
        WJLogError(@"需要keyChain cache实现");
        @throw [[NSException alloc] initWithName:@"WJSessionServiceException" reason:@"需要keyChain cache实现" userInfo:nil];
    }
    if (WJ_CACHE_IS_VALID(WJCacheTypeUserDefaults)) {
        self.userDefaultsCache = WJ_CACHE_OBJECT(WJCacheTypeUserDefaults);
    } else {
        WJLogError(@"需要userDefaults cache实现");
        @throw [[NSException alloc] initWithName:@"WJSessionServiceException" reason:@"需要userDefaults cache实现" userInfo:nil];
    }
    
    [self loadSessionTokenSerializer];
    self.lock = [[NSRecursiveLock alloc] init];
    [self loadStorage];
}


#pragma mark IWJSessionService
-(id<IWJToken>) getToken {
    if ([self isLogined]) {
        return _token;
    }
    return nil;
}

-(void) logined:(id<IWJToken>) token {
    [_lock lock];
    if (token) {
        self.token = token;
        [self syncStorage];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginedNotification object:self];
    }
    [_lock unlock];
}

-(void) logout {
    [_lock lock];
    if (_token) {
        self.token = nil;
        [self deleteStorage];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLogoutNotification object:self];
    }
    [_lock unlock];
}

-(BOOL) isLogined {
    if (_token == nil)
        return NO;
    if (([_token invalidTime] > 0 && [_token invalidTime] < [[NSDate date] timeIntervalSince1970]) || ![_token currentUid]) {
        [self logout];
        return NO;
    }
    return YES;
}

@end
