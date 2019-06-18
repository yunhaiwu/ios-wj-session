//
//  WJAnnotation.h
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
#import "WJServiceRegisterDefine.h"
#import "WJAppContextDefines.h"

#ifndef WJModSectName
#define WJModSectName "WJAppMods"
#endif

#ifndef WJServiceSectName
#define WJServiceSectName "WJModServices"
#endif

#ifndef WJAspectsSectName
#define WJAspectsSectName "WJModAspects"
#endif


#define WJAppContextData(sectname) __attribute((used, section("__DATA,"#sectname" ")))


#define WJModule(name) \
class WJAnnotation; char * k##name##mod WJAppContextData(WJAppMods) = ""#name"";

#define WJServiceReigisterTemplate2(S,I) \
class WJAnnotation; char * k##S##_##I##service WJAppContextData(WJModServices) = ""#S":"#I"";

#define WJServiceReigisterTemplate1(I) \
class WJAnnotation; char * kWJService_##I##service WJAppContextData(WJModServices) = "WJService:"#I"";


#define WJService(...)  WJMacroDefine2Arguments(__VA_ARGS__, WJServiceReigisterTemplate2, WJServiceReigisterTemplate1, ...)(__VA_ARGS__)


#define WJAspect(name) \
class WJAnnotation; char * k##name##aspect WJAppContextData(WJModAspects) = ""#name"";

/**
 Annotation
 */
@interface WJAnnotation : NSObject

+ (NSArray*)getAnnotationModuleDefines;

+ (NSArray*)getAnnotationServiceDefines;

+ (NSArray*)getAnnotationAspectDefines;

@end
