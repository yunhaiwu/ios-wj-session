//
//  WJAspectWrapper.m
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

#import "WJAspectWrapper.h"

@interface WJAspectWrapper ()

@property (nonatomic, assign) Class aspectClass;

@property (nonatomic, copy) NSDictionary<NSString*, NSMutableSet<NSString*>*> *pointcuts;

@end

@implementation WJAspectWrapper

- (instancetype)initWithAspectClass:(Class)aspectClass {
    self = [super init];
    if (self) {
        if ([aspectClass conformsToProtocol:@protocol(WJAspect)]) {
            self.aspectClass = aspectClass;
            self.aspect = [[aspectClass alloc] init];
            [self handlePointExpressions];
        }
    }
    return self;
}

- (void)handlePointExpressions {
    NSMutableDictionary<NSString*, NSMutableSet<NSString*>*> *pointcuts = [[NSMutableDictionary alloc] init];
    NSString *pointcutExpressions = [self.aspect pointcutExpressions];
    NSArray<NSString*> *expressions = [pointcutExpressions componentsSeparatedByString:@";"];
    for (NSString *e in expressions) {
        NSRange range = [e rangeOfString:@"("];
        if (range.length == 1) {
            NSString *className = [e substringToIndex:range.location];
            NSString *methodName = [e substringWithRange:NSMakeRange(range.location + 1, e.length - range.location - 2)];
            NSMutableSet *methods = pointcuts[className];
            if (!methods) {
                methods = [[NSMutableSet alloc] init];
                [pointcuts setObject:methods forKey:className];
            }
            [methods addObject:methodName];
        }
    }
    self.pointcuts = pointcuts;
}

- (NSSet<NSString*>*)pointcutClassNames {
    NSArray *clsList = [self.pointcuts allKeys];
    if ([clsList count] > 0) {
        return [[NSSet alloc] initWithArray:clsList];
    }
    return nil;
}

- (NSSet<NSString*>*)pointcutMethods:(NSString*)className {
    NSMutableSet *result = [[NSMutableSet alloc] init];
    NSMutableSet *generalMethods =  self.pointcuts[@"*"];
    if ([generalMethods count] > 0) [result addObjectsFromArray:generalMethods.allObjects];
    NSMutableSet *classMethods = self.pointcuts[className];
    if ([classMethods count] > 0) [result addObjectsFromArray:classMethods.allObjects];
    return result;
}

- (NSString *)moduleId {
    NSString *moduleId = [self.aspectClass moduleId];
    if (!moduleId) moduleId = WJ_MODULE_GLOBAL_DEFAULT_MODULE_ID;
    return moduleId;
}

- (NSString*)aspectId {
    NSString *aspectId = [self.aspectClass aspectId];
    if (!aspectId) aspectId = NSStringFromClass(self.aspectClass);
    return aspectId;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[WJAspectWrapper class]]) {
        return [[self aspectId] isEqual:[object aspectId]];
    }
    return NO;
}

- (NSUInteger)hash {
    return [[self aspectId] hash];
}

@end
