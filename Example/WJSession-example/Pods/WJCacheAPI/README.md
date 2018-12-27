# WJCacheAPI

http 请求组件api

### CocoaPods 安装

```
pod WJCacheAPI
```

### 要求
* ARC支持
* iOS 6.0+


### 使用方法

* 在WJConfig配置中心：

```
//WJHttpEngineAPI在配置中心名称
WJCacheAPI : {
    keychainService:(String)秘钥存储service default：[[NSBundle mainBundle] bundleIdentifier]
    keychainAccessGroup:(String)秘钥存储accessGroup  default: ""
    caches:(Array<String>)必须实现协议IWJCache
}

```
