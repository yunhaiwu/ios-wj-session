



# WJAppContext

模块化、服务化中间件

## CocoaPods 安装

```
在Podfile 文件头部添加：
source：https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git
	
pod WJAppContext	
```

## 要求
* ARC支持
* iOS 5.0+

## 使用方法
### 1、在Config中配置

```
	WJAppContext:(NSDictionary<NSString*,NSObject*>*)
			modules:(NSArray<NSString*>*)
			aspects:(NSArray<NSString*>*)
			services:(NSDictionary<NSString*, NSArray<NSString*>*>*)
			
	也可以通过Annotation标记注册模块和服务
```

### 2、在AppDelegate中需要实现方法中需要调用 WJApplicationContext中对应的方法。

```
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[WJApplicationContext sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

注意：所有的AppDelegate已实现方法都需要调用WJApplicationContext中对应的方法，要不然WJModule实现类无法接收生命周期方法。

```

### 3、模块：所有模块必须继承 AbstractBaseModule 类

```
1、使用注解注册服务

#import "AbstractBaseModule.h"
/**
	用户模块
*/
@WJModule(UserModule)
@interface UserModule : AbstractBaseModule

// 模块初始化
-(void)onModuleInit:(id<WJModuleContext>)context {}

// 准备加载
-(void)onModuleWillLoad:(id<WJModuleContext>)context {}

// 已加载
-(void)onModuleDidLoad:(id<WJModuleContext>)context {}

// 准备卸载
-(void)onModuleWillDestroy:(id<WJModuleContext>)context {}

// 已卸载
-(void)onModuleDidDestroy:(id<WJModuleContext>)context {}

// 其他模块销毁通知
-(void)onModuleDidOtherModuleDestroyNotify:(NSString*)moduleId {}

@end


//手动注册服务
[WJAppContext registerModule:[UserModule class]];

//卸载服务
[WJAppContext unRegisterModule:[UserModule class]];

```

### 4、服务： 

```
#import "IUserService.h"

@WJService(IUserService, UserService)
@interface UserService : NSObject<IUserService>
@end

@WJService(IUserService, UserService2)
@interface UserService2 : NSObject<IUserService>
@end

//所有没有指定协议的服务默认都实现了WJService服务
@WJService(AccountService)
@interface AccountService : NSObject
@end

//调用服务
AccountService *service = WJAppContextCreateServiceById(@"AccountService");

id<IUserService> userService = WJAppContextCreateService(@protocol(IUserService));
if ([userService isLogined]) {
     [userService logout];
}

id<IUserService> userService = WJAppContextCreateServiceByName(@"IUserService");
if ([userService isLogined]) {
     [userService logout];
}

//如果一个服务有多种实现，获取服务时可以根据服务id获取，如果不传Id，则获取其中某一个服务
id<IUserService> userService2 = WJAppContextCreateService(@protocol(IUserService)， @"UserService2");
if ([userService2 isLogined]) {
     [userService logout];
}

id<IUserService> userService2 = WJAppContextCreateServiceByName(@"IUserService"， @"UserService2");
if ([userService2 isLogined]) {
     [userService logout];
}

```
