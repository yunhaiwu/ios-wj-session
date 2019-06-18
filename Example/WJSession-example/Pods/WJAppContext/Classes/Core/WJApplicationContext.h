//
//  WJAppContext.h
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

#import <UIKit/UIKit.h>
#import "WJAppContextDefines.h"


#define WJAppContext                                                                [WJApplicationContext sharedInstance]


//获取Service
#define WJAppContextCreateServiceTemplate1(P)                                       [[WJApplicationContext sharedInstance] createService:P]

#define WJAppContextCreateServiceTemplate2(P,S)                                     [[WJApplicationContext sharedInstance] createService:P serviceId:S]

#define WJAppContextCreateService(...)                                              WJMacroDefine2Arguments(__VA_ARGS__, WJAppContextCreateServiceTemplate2, WJAppContextCreateServiceTemplate1, ...)(__VA_ARGS__)


#define WJAppContextCreateServiceById(ID)                                          [[WJApplicationContext sharedInstance] createServiceById:ID]


#define WJAppContextCreateServiceByProtocolNameTemplate1(P)                         [[WJApplicationContext sharedInstance] createServiceByName:P]
#define WJAppContextCreateServiceByProtocolNameTemplate2(P, S)                      [[WJApplicationContext sharedInstance] createServiceByName:P serviceId:S]
#define WJAppContextCreateServiceByProtocolName(...)                                WJMacroDefine2Arguments(__VA_ARGS__, WJAppContextCreateServiceByProtocolNameTemplate2, WJAppContextCreateServiceByProtocolNameTemplate1, ...)(__VA_ARGS__)


/**
 *  应用程序上下文环境
 */
@interface WJApplicationContext : NSObject<UIApplicationDelegate>

/**
 单利对象
 */
+ (instancetype)sharedInstance;

/**
 动态注册模块
 */
- (void)registerModule:(Class)moduleClass;

/**
 批量注册模块
 */
- (void)registerModules:(NSSet<Class> *)moduleClassSet;

/**
 卸载模块
 */
- (void)unRegisterModule:(Class)moduleClass;

/**
 注册服务
 @param serviceProtocol 服务协议
 @param serviceClass 服务类
 */
- (void)registerService:(Protocol *)serviceProtocol serviceClass:(Class) serviceClass;

/**
 注册服务
 @param serviceClass 服务类型
 */
- (void)registerService:(Class)serviceClass;

/**
 获取服务对象
 @param serviceProtocol 服务协议
 @return 服务对象
 */
- (id)createService:(Protocol*)serviceProtocol;

/**
 获取服务对象、如果一个服务协议对应多个服务对象，则可以通过serviceId标记具体获取哪一个
 @param serviceProtocol 服务协议
 @param serviceId 服务id
 @return 服务对象
 */
- (id)createService:(Protocol *)serviceProtocol serviceId:(NSString*)serviceId;

/**
 获取服务对象
 @param protocolName 服务协议名称
 @return 服务对象
 */
- (id)createServiceByName:(NSString *)protocolName;

/**
 获取服务对象、如果一个服务协议对应多个服务对象，则可以通过serviceId标记具体获取哪一个
 @param protocolName 服务协议名称
 @param serviceId 服务id
 @return 服务对象
 */
- (id)createServiceByName:(NSString *)protocolName serviceId:(NSString*)serviceId;

/**
 根据服务id获取服务对象
 @param serviceId 服务id
 */
- (id)createServiceById:(NSString *)serviceId;

@end
