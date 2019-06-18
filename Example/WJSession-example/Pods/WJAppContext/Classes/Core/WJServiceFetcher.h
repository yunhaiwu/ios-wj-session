//
//  WJServiceFetcher.h
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

#import <Foundation/Foundation.h>

@protocol WJServiceFetcher <NSObject>

/**
 根据服务协议和服务id获取服务
 */
- (id)createService:(Protocol*) serviceProtocol serviceId:(NSString*) serviceId;

/**
 根据服务协议获取服务
 */
- (id)createService:(Protocol*) serviceProtocol;

/**
 根据服务协议名称和服务id获取服务
 */
- (id)createServiceByProtocolName:(NSString*) serviceProtocol serviceId:(NSString*) serviceId;

/**
 根据服务协议名称获取服务
 */
- (id)createServiceByProtocolName:(NSString*) serviceProtocol;

/**
 根据服务id获取服务
 */
- (id)createServiceById:(NSString*)serviceId;

@end
