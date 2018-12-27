//
//  IWJToken.h
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

@protocol IWJToken <NSObject>

/**
 token code
 */
-(NSString*) currentToken;


/**
 刷新token的refreshToken
 */
-(NSString*) refreshToken;

/**
 用户id
 */
-(id) currentUid;


/**
 失效时间(时间戳，计算是需要注意)
 */
-(NSTimeInterval) invalidTime;


/**
 数据完整性验证token
 */
-(NSString*)dataSafeKey;

@end
