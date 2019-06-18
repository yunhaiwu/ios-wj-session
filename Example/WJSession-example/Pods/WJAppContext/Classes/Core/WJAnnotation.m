//
//  WJAnnotation.m
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

#import "WJAnnotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>
#import "WJLoggingAPI.h"

@interface WJAnnotation ()

@property (nonatomic, copy) NSArray *modules,*services,*aspects;

+ (instancetype)shareInstance;

@end

@implementation WJAnnotation

+ (instancetype)shareInstance {
    static WJAnnotation *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJAnnotation alloc] init];
    });
    return instance;
}

- (void)performInitModules:(NSArray*)modules services:(NSArray*)services aspects:(NSArray*)aspects {
    self.modules = modules;
    self.services = services;
    self.aspects = aspects;
}

+ (NSArray*)getAnnotationModuleDefines {
    return [[WJAnnotation shareInstance] modules];
}

+ (NSArray*)getAnnotationServiceDefines {
    return [[WJAnnotation shareInstance] services];
}

+ (NSArray*)getAnnotationAspectDefines {
    return [[WJAnnotation shareInstance] aspects];
}

@end

NSArray<NSString *>* WJReadConfiguration(char *sectionName,const struct mach_header *mhp);

static BOOL initializedFlag = NO;
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    if (!initializedFlag) {
        initializedFlag = YES;
        NSArray *modules = WJReadConfiguration(WJModSectName, mhp);
        NSArray *services = WJReadConfiguration(WJServiceSectName, mhp);
        NSArray *aspects = WJReadConfiguration(WJAspectsSectName, mhp);
        [[WJAnnotation shareInstance] performInitModules:modules services:services aspects:aspects];
    }
    
}

__attribute__((constructor))
void initProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

NSArray<NSString *>* WJReadConfiguration(char *sectionName,const struct mach_header *mhp)
{
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        if(str) [configs addObject:str];
    }
    
    return configs;
}
