//
//  AbstractBaseModule.m
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


#import "AbstractBaseModule.h"
#import "SimpleModuleContext.h"


@interface AbstractBaseModule ()

@property(nonatomic, strong) SimpleModuleContext *context;

@end

@implementation AbstractBaseModule

-(instancetype)initWithServicesRegister:(id<WJServiceRegister>)servicesRegister aspectsRegister:(id<WJAspectRegister>)aspectsRegister {
    self = [super init];
    if (self) {
        self.context = [[SimpleModuleContext alloc] initWithModuleId:[self getModuleId] servicesRegister:servicesRegister aspectsRegister:aspectsRegister];
    }
    return self;
}

-(NSString*)getModuleId {
    NSString *modId = [self.class moduleId];
    if (!modId) modId = NSStringFromClass(self.class);
    return modId;
}

#pragma mark WJModule
- (id<WJModuleContext>)modContext {
    return _context;
}

+ (NSString*)moduleId {
    return NSStringFromClass(self);
}

+ (int)modPriority {
    return WJ_MODULE_LOADING_PRIORITY_DEFAULT;
}

- (void)onModuleInit:(id<WJModuleContext>)context {}

- (void)onModuleWillLoad:(id<WJModuleContext>)context {}

- (void)onModuleDidLoad:(id<WJModuleContext>)context {}

- (void)onModuleWillDestroy:(id<WJModuleContext>)context {}

- (void)onModuleDidDestroy:(id<WJModuleContext>)context {}

- (void)onModuleDidOtherModuleDestroyNotify:(NSString *)moduleId {}

@end
