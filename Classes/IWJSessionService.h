//
//  IWJSessionService.h
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

#import <Foundation/Foundation.h>
#import "IWJToken.h"

/*
 用户登录通知
 */
extern NSString * const UserLoginedNotification;

/*
 用户注销通知
 */
extern NSString * const UserLogoutNotification;

/**
 会话工具
 */
@protocol IWJSessionService <NSObject>

/**
 token object
 */
-(id<IWJToken>) getToken;

/**
 登录
 */
-(void) logined:(id<IWJToken>) token;

/**
 注销
 */
-(void) logout;

/**
 是否已登录
 */
-(BOOL) isLogined;

@end
