//
//  ISessionDataFormatter.h
//  WJAppContext-example
//
//  Created by 吴云海 on 17/4/6.
//  Copyright © 2017年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJToken.h"


/**
 回话数据格式化工具
 */
@protocol IWJTokenSerializerService <NSObject>

/**
 将NSData转换成Token
 */
-(id<IWJToken>)deserialization:(NSData*)data;

/**
 将token转换成NSData
 */
-(NSData*)serialization:(id<IWJToken>)token;


@end
