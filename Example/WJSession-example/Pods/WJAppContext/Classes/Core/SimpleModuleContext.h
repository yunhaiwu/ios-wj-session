//
//  SimpleModuleContext.h
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
#import "WJModuleContext.h"
#import "WJServiceRegister.h"
#import "WJAspectRegister.h"

__attribute__((objc_subclassing_restricted))
@interface SimpleModuleContext : NSObject<WJModuleContext>

- (instancetype)initWithModuleId:(NSString*)moduleId servicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister;

@end
