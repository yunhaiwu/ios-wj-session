//
//  NSNotificationCenter+WJExtension.h
//
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by Yunhai.Wu on 16/1/4.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//POST
#define WJ_NOTIFY_POST(N)                                   [NSNotificationCenter wj_postNotificationOnMainThread:N]
#define WJ_NOTIFY_POST_WAIT(N,W)                            [NSNotificationCenter wj_postNotificationOnMainThread:N waitUntilDone:W]
#define WJ_NOTIFY_POST_NAME_OBJECT(N,O)                     [NSNotificationCenter wj_postNotificationOnMainThreadWithName:N object:O]
#define WJ_NOTIFY_POST_NAME_OBJECT_USERINFO(N,O,U)          [NSNotificationCenter wj_postNotificationOnMainThreadWithName:N object:O userInfo:U]
#define WJ_NOTIFY_POST_NAME_OBJECT_USERINFO_WAIT(N,O,U,W)   [NSNotificationCenter wj_postNotificationOnMainThreadWithName:N object:O userInfo:U waitUntilDone:W]

//REMOVE
#define WJ_NOTIFY_REMOVE(OBS)                               [[NSNotificationCenter defaultCenter] removeObserver:OBS]
#define WJ_NOTIFY_REMOVE_NAME_OBJECT(OBS,N,O)               [[NSNotificationCenter defaultCenter] removeObserver:OBS name:N object:O]

//ADD
#define WJ_NOTIFY_ADD_OBSERVER(OBS,S,N,O)                   [[NSNotificationCenter defaultCenter] addObserver:OBS selector:S name:N object:O]


@interface NSNotificationCenter (WJExtension)

+(void) wj_postNotificationOnMainThread:(NSNotification *)notification;

+(void) wj_postNotificationOnMainThread:(NSNotification *)notification
                         waitUntilDone:(BOOL)wait;

+(void) wj_postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object;

+(void) wj_postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo;

+(void) wj_postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait;



@end
