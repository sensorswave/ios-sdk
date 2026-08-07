# Sensors Wave iOS SDK

[Sensors Wave](http://sensorswave.com/) iOS SDK 是专为 iOS 应用设计的客户端数据采集和 A/B 实验工具。

## SDK 使用指南

### 1. 集成 SDK

#### CocoaPods 集成（推荐）

在您的 `Podfile` 中添加：

```ruby
pod 'SensorswaveSDK'
```

然后在终端运行：

```bash
pod install
```

#### 手动集成

1. 从 [GitHub](https://github.com/sensorswave/ios-sdk) 获取 SDK 的二进制包
将 SensorswaveSDK > xcframework 目录下的 SensorswaveSDK.xcframework 包拖到 Xcode 项目，并选中 Copy items if needed
2. 在项目设置中添加以下框架：
   - `Foundation.framework`
   - `UIKit.framework`
   - `CoreTelephony.framework`

### 2. 初始化 SDK

在 `AppDelegate.swift` 中的 `application(_:didFinishLaunchingWithOptions:)` 方法中初始化 SDK：

```swift
import UIKit
import SensorswaveSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 创建配置
        let config = SensorswaveConfig()
        config.debug = false                     // 生产环境关闭调试
        config.apiHost = "https://api.example.com"  // 替换为您的 API 地址
        config.autoCapture = true              // 启用自动采集
        config.enableClickTrack = true           // 启用点击追踪
        config.enableAB = true                  // 启用 A/B 测试
        config.abRefreshInterval = 5 * 60 * 1000  // 5 分钟刷新间隔
        config.batchSend = false                // 启用批量发送（默认关闭）

        // 初始化 SDK
        Sensorswave.getInstance().setup(
            sourceToken: "your-source-token",  // 替换为您的 Source Token
            config: config
        )

        return true
    }
}
```

**注意：** 请将 `your-api-host.com` 和 `your-source-token` 替换为您的实际值。

#### 初始化 SDK（Objective-C）

在 `AppDelegate.m` 中的 `application:didFinishLaunchingWithOptions:` 方法中初始化 SDK：

```objc
#import <UIKit/UIKit.h>
#import <SensorswaveSDK/SensorswaveSDK-Swift.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 创建配置
    SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
    config.debug = NO;                     // 生产环境关闭调试
    config.apiHost = @"https://api.example.com";  // 替换为您的 API 地址
    config.autoCapture = YES;              // 启用自动采集
    config.enableClickTrack = YES;         // 启用点击追踪
    config.enableAB = YES;                 // 启用 A/B 测试
    config.abRefreshInterval = 5 * 60 * 1000;  // 5 分钟刷新间隔
    config.batchSend = NO;                 // 启用批量发送（默认关闭）

    // 初始化 SDK
    [[Sensorswave getInstance] setup:@"your-source-token" config:config];

    return YES;
}

@end
```

### 3. 追踪自定义事件

```swift
// 追踪简单事件
Sensorswave.getInstance().trackEvent(eventName: "ButtonClick")

// 追踪带有属性的事件
Sensorswave.getInstance().trackEvent(eventName: "ButtonClick", properties: [
    "button_name": "submit",
    "page": "home",
    "category": "user_action"
])
```

```objc
// 追踪简单事件
[[Sensorswave getInstance] trackEvent:@"ButtonClick" properties:nil];

// 追踪带有属性的事件
[[Sensorswave getInstance] trackEvent:@"ButtonClick"
                                     properties:@{
                                         @"button_name": @"submit",
                                         @"page": @"home",
                                         @"category": @"user_action"
                                     }];
```

## 配置选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `debug` | Bool | false | 是否启用调试模式，用于输出详细日志 |
| `apiHost` | String | '' | API 服务器地址，用于发送事件数据 |
| `autoCapture` | Bool | true | 是否自动采集事件（页面浏览、应用启动等） |
| `enableClickTrack` | Bool | false | 是否启用自动点击追踪 |
| `enableAB` | Bool | false | 是否启用 A/B 测试功能 |
| `abRefreshInterval` | TimeInterval | 600000 (10分钟) | A/B 测试配置刷新间隔（毫秒），最小 30 秒 |
| `batchSend` | Bool | false | 是否启用批量发送（收集10条事件后发送或每5秒发送一次） |
| `optOutCapturing` | Bool | false | 是否默认禁用采集（合规开关）。启用后 SDK 不会采集、发送或持久化任何事件 |
| `persistOptOut` | Bool | false | 是否将 opt-out 状态持久化到 UserDefaults，使其在 App 重启后保留 |

**配置示例：**

```swift
let config = SensorswaveConfig()
config.debug = true
config.apiHost = "https://api.example.com"
config.autoCapture = true
config.enableClickTrack = true
config.enableAB = true
config.abRefreshInterval = 5 * 60 * 1000  // 5 分钟
config.batchSend = true  // 默认为 false，启用可减少网络请求
```

```objc
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.debug = YES;
config.apiHost = @"https://api.example.com";
config.autoCapture = YES;
config.enableClickTrack = YES;
config.enableAB = YES;
config.abRefreshInterval = 5 * 60 * 1000;  // 5 分钟
config.batchSend = YES;  // 默认为 NO，启用可减少网络请求
```

## API 方法

### 事件追踪

#### trackEvent

手动追踪自定义事件。

**参数：**
- `eventName` (String, 必需): 要追踪的事件名称
- `properties` (Dictionary<String, Any>, 可选): 事件属性

**返回值：** 无

**示例：**

```swift
// 简单事件
Sensorswave.getInstance().trackEvent(eventName: "UserLogin")

// 带属性的事件
Sensorswave.getInstance().trackEvent(eventName: "PurchaseCompleted", properties: [
    "product_id": "12345",
    "amount": 99.99,
    "currency": "USD",
    "category": "ecommerce"
])
```

```objc
// 简单事件
[[Sensorswave getInstance] trackEvent:@"UserLogin" properties:nil];

// 带属性的事件
[[Sensorswave getInstance] trackEvent:@"PurchaseCompleted"
                                     properties:@{
                                         @"product_id": @"12345",
                                         @"amount": @99.99,
                                         @"currency": @"USD",
                                         @"category": @"ecommerce"
                                     }];
```

#### track

追踪完整事件对象（高级方法）。

**参数：**
- `event` (AdvanceEvent，必填)：完整事件对象，包含以下字段：
  - `event` (string，必填)：事件名称
  - `properties` (Dictionary<string, any>，可选)：事件属性
  - `time` (number，必填)：时间戳（毫秒）
  - `anon_id` (string，可选)：匿名用户 ID
  - `login_id` (string，可选)：登录用户 ID。login_id 和 anon_id 必须传一个，同时传递时，优先使用 login_id
  - `trace_id` (string，必填)：请求追踪 ID
  - `user_properties` (Dictionary<string, any>，可选)：用户属性

**返回值：** 无

**示例：**

```swift
// 使用完整事件对象
Sensorswave.getInstance().track(event: [
    "event": "CustomEvent",
    "properties": [
        "key1": "value1",
        "key2": "value2"
    ],
    "time": Int64(Date().timeIntervalSince1970 * 1000),
    "trace_id": UUID().uuidString,
    "login_id": "user_12345"
])
```

```objc
// 使用完整事件对象
[[Sensorswave getInstance] track:@{
    @"event": @"CustomEvent",
    @"properties": @{
        @"key1": @"value1",
        @"key2": @"value2"
    },
    @"time": @([[NSDate date] timeIntervalSince1970] * 1000),
    @"trace_id": [[NSUUID UUID] UUIDString],
    @"login_id": @"user_12345"
}];
```

### 用户属性

#### profileSet

设置用户属性。如果属性已存在，将被覆盖。

**参数：**
- `properties` (Dictionary<String, Any>, 必需): 要设置的用户属性

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().profileSet([
    "name": "张三",
    "age": 30,
    "plan": "premium"
])
```

```objc
[[Sensorswave getInstance] profileSet:@{
    @"name": @"张三",
    @"age": @30,
    @"plan": @"premium"
}];
```

#### profileSetOnce

设置一次性用户属性。如果属性不存在则设置，如果已存在则忽略。

**参数：**
- `properties` (Dictionary<String, Any>, 必需): 要设置的用户属性

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().profileSetOnce([
    "signup_date": "2024-01-15",
    "initial_referrer": "google",
    "initial_campaign": "spring_sale"
])
```

```objc
[[Sensorswave getInstance] profileSetOnce:@{
    @"signup_date": @"2024-01-15",
    @"initial_referrer": @"google",
    @"initial_campaign": @"spring_sale"
}];
```

#### profileIncrement

递增数值类型的用户属性。仅支持数值类型属性。

**参数：**
- `properties` (Dictionary<String, Any>, 必需): 要递增的属性，值为数值

**返回值：** 无

**示例：**

```swift
// 递增单个属性
Sensorswave.getInstance().profileIncrement(properties: [
    "login_count": 1
])

// 递增多个属性
Sensorswave.getInstance().profileIncrement(properties: [
    "login_count": 1,
    "points_earned": 100,
    "purchases_count": 1
])
```

```objc
// 递增单个属性
[[Sensorswave getInstance] profileIncrement:@{@"login_count": @1}];

// 递增多个属性
[[Sensorswave getInstance] profileIncrement:@{
    @"login_count": @1,
    @"points_earned": @100,
    @"purchases_count": @1
}];
```

#### profileAppend

向列表类型的用户属性追加值，**不去重**。

**参数：**
- `properties` (Dictionary<String, Any>, 必需): 要追加的属性，值为数组

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().profileAppend(properties: [
    "categories_viewed": ["electronics", "mobile_phones"],
    "tags": ["new_customer", "q1_2024"]
])
```

```objc
[[Sensorswave getInstance] profileAppend:@{
    @"categories_viewed": @[@"electronics", @"mobile_phones"],
    @"tags": @[@"new_customer", @"q1_2024"]
}];
```

#### profileUnion

向列表类型的用户属性追加值，**去重**。

**参数：**
- `properties` (Dictionary<String, Any>, 必需): 要追加的属性，值为数组

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().profileUnion(properties: [
    "interests": ["technology", "gaming"],
    "newsletter_subscriptions": ["tech_news"]
])
```

```objc
[[Sensorswave getInstance] profileUnion:@{
    @"interests": @[@"technology", @"gaming"],
    @"newsletter_subscriptions": @[@"tech_news"]
}];
```

#### profileUnset

清除特定的用户属性（设置为 null）。

**参数：**
- `key` (String, 必需): 要清除的单个属性名
- `keys` ([String], 必需): 要清除的多个属性名

**返回值：** 无

**示例：**

```swift
// 清除单个属性
Sensorswave.getInstance().profileUnset(key: "temporary_campaign")

// 清除多个属性
Sensorswave.getInstance().profileUnset(keys: ["old_plan", "expired_flag", "temp_id"])
```

```objc
// 清除单个属性
[[Sensorswave getInstance] profileUnsetKey:@"temporary_campaign"];

// 清除多个属性
[[Sensorswave getInstance] profileUnsetKeys:@[@"old_plan", @"expired_flag", @"temp_id"]];
```

#### profileDelete

删除当前用户的所有用户属性数据。此操作不可撤销。

**参数：** 无

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().profileDelete()
```

```objc
[[Sensorswave getInstance] profileDelete];
```

### 用户识别

#### identify

设置当前用户的登录 ID，并发送绑定事件（$Identify），将匿名行为与已识别用户关联。

**参数：**
- `loginId` (String, 必需): 用户的唯一标识符（如邮箱、用户 ID、用户名）

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().identify(loginId: "user_12345")
```

```objc
[[Sensorswave getInstance] identify:@"user_12345"];
```

#### setLoginId

设置当前用户的登录 ID，但**不发送**绑定事件。

**参数：**
- `loginId` (String, 必需): 用户的唯一标识符

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().setLoginId(loginId: "user_12345")
```

```objc
[[Sensorswave getInstance] setLoginId:@"user_12345"];
```

#### getLoginId

获取当前用户的登录 ID。如果用户未登录（即未通过 `identify` 或 `setLoginId` 设置登录 ID），返回空字符串。

**参数：** 无

**返回值：** `String` - 当前登录 ID，未设置时为空字符串

**示例：**

```swift
let loginId = Sensorswave.getInstance().getLoginId()
if loginId.isEmpty {
    // 用户未登录
} else {
    // 使用 loginId
}
```

```objc
NSString *loginId = [[Sensorswave getInstance] getLoginId];
if (loginId.length == 0) {
    // 用户未登录
} else {
    // 使用 loginId
}
```

#### getAnonId

获取当前设备的匿名 ID。匿名 ID 在首次访问时生成并持久化保存，因此该方法始终返回非空字符串。

**参数：** 无

**返回值：** `String` - 匿名 ID（始终非空）

**示例：**

```swift
let anonId = Sensorswave.getInstance().getAnonId()
```

```objc
NSString *anonId = [[Sensorswave getInstance] getAnonId];
```

### 公共属性

#### registerCommonProperties

注册公共属性，这些属性将包含在所有事件中。

**参数：**
- `properties` (Dictionary<String, Any>, 必需): 要注册的属性

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().registerCommonProperties(properties: [
    // 静态属性
    "app_version": "1.0.0",
    "environment": "production",
    "user_role": "guest"
])
```

```objc
[[Sensorswave getInstance] registerCommonProperties:@{
    // 静态属性
    @"app_version": @"1.0.0",
    @"environment": @"production",
    @"user_role": @"guest"
}];
```

**注意：** iOS SDK 目前只支持静态属性。如需动态属性，请在每次事件发送前手动更新。

#### clearCommonProperties

清除特定的已注册公共属性。

**参数：**
- `keys` ([String], 必需): 要清除的属性名数组

**返回值：** 无

**示例：**

```swift
Sensorswave.getInstance().clearCommonProperties(keys: ["app_version", "user_role"])
```

```objc
[[Sensorswave getInstance] clearCommonProperties:@[@"app_version", @"user_role"]];
```

### A/B 测试

#### checkFeatureGate

检查功能开关（Feature Flag）是否对当前用户启用。

**参数：**
- `key` (String, 必需): 功能开关的键名
- `callback` (Bool -> Void, 必需): 回调函数，返回功能开关状态

**返回值：** 无

**示例：**

```swift
// 检查功能开关
Sensorswave.getInstance().checkFeatureGate(key: "new_checkout_flow") { isEnabled in
    DispatchQueue.main.async {
        if isEnabled {
            // 启用新功能
            self.showNewCheckout()
        } else {
            // 使用旧功能
            self.showOldCheckout()
        }
    }
}
```

```objc
// 检查功能开关
[[Sensorswave getInstance] checkFeatureGate:@"new_checkout_flow" callback:^(BOOL isEnabled) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isEnabled) {
            // 启用新功能
            [self showNewCheckout];
        } else {
            // 使用旧功能
            [self showOldCheckout];
        }
    });
}];
```

#### getExperiment

获取当前用户的实验配置。

**参数：**
- `key` (String, 必需): 实验的键名
- `callback` ([String: Any] -> Void, 必需): 回调函数，返回实验配置

**返回值：** 无

**示例：**

```swift
// 获取实验配置
Sensorswave.getInstance().getExperiment(key: "homepage_layout") { config in
    DispatchQueue.main.async {
        if config.isEmpty {
            // 默认配置
            self.applyDefaultLayout()
            return
        }

        // 应用实验配置
        if let layoutType = config["layout_type"] as? String {
            self.applyLayout(layoutType)
        }
    }
}
```

```objc
// 获取实验配置
[[Sensorswave getInstance] getExperiment:@"homepage_layout" callback:^(NSDictionary<NSString *,id> *config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (config.count > 0) {
            // 应用实验配置
            NSString *layoutType = config[@"layout_type"];
            [self applyLayout:layoutType];
        } else {
            // 默认配置
            [self applyDefaultLayout];
        }
    });
}];
```

#### getFeatureConfig

获取当前用户的功能配置（返回动态类型）。

**参数：**
- `key` (String, 必需): 功能配置的键名
- `callback` (Any -> Void, 必需): 回调函数，返回功能配置

**返回值：** 无

**示例：**

```swift
// 获取功能配置
Sensorswave.getInstance().getFeatureConfig(key: "app_settings") { config in
    DispatchQueue.main.async {
        // 处理不同的返回类型
        if let dictConfig = config as? [String: Any] {
            // JSON 对象: {"theme": "dark", "max_size": 100}
            if let theme = dictConfig["theme"] as? String {
                self.applyTheme(theme)
            }
            if let maxSize = dictConfig["max_size"] as? Int {
                self.updateMaxSize(maxSize)
            }
        } else if let stringConfig = config as? String {
            // 原始字符串值
            self.applyRawConfig(stringConfig)
        } else if let dictConfig = config as? [String: Any], dictConfig.isEmpty {
            // 空配置 - 使用默认值
            self.applyDefaultConfig()
        }
    }
}
```

```objc
// 获取功能配置
[[Sensorswave getInstance] getFeatureConfig:@"app_settings" callback:^(id config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([config isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictConfig = (NSDictionary *)config;
            if (dictConfig.count > 0) {
                // 应用功能配置
                NSString *theme = dictConfig[@"theme"];
                NSNumber *maxSize = dictConfig[@"max_size"];
                [self applyTheme:theme];
                [self updateMaxSize:[maxSize integerValue]];
            } else {
                // 空配置 - 使用默认值
                [self applyDefaultConfig];
            }
        } else if ([config isKindOfClass:[NSString class]]) {
            // 原始字符串值
            NSString *stringConfig = (NSString *)config;
            [self applyRawConfig:stringConfig];
        }
    });
}];
```

**注意：** 此方法返回动态类型 (`Any`)。服务端返回的值可能是 JSON 字符串，会自动解析为字典。如果解析失败，返回原始值（字符串）。如果配置未找到，返回空字典。

**配置说明：**

A/B 测试需要先在配置中启用：

```swift
config.enableAB = true
config.abRefreshInterval = 10 * 60 * 1000  // 10 分钟刷新间隔
```

**配置说明（Objective-C）：**

```objc
config.enableAB = YES;
config.abRefreshInterval = 10 * 60 * 1000;  // 10 分钟刷新间隔
```

## 自动采集的事件

当 `autoCapture` 启用时，SDK 会自动采集以下事件：

- **$AppStart** - 应用启动事件
- **$AppEnd** - 应用结束事件
- **$AppInstall** - 应用首次安装事件（仅一次）
- **$AppPageView** - 页面浏览事件
- **$AppPageLeave** - 页面离开事件

当 `enableClickTrack` 启用时，还会自动采集：
- **$AppClick** - 点击事件

## 线程安全

SDK 中的所有操作都是线程安全的：

- **PersistentQueue** - 使用 `NSLock` 保护所有队列操作
- **网络请求** - 支持多线程并发
- **用户属性** - 使用同步机制保证数据一致性

## 批量发送

启用批量发送可以减少网络请求次数，提高性能：

```swift
config.batchSend = true  // 默认为 false
```

**Objective-C：**

```objc
config.batchSend = YES;  // 默认为 NO
```

**批量发送行为：**
- 收集 10 条事件后立即发送
- 或 5 秒定时发送
- 使用线程安全的队列管理

**优势：**
- 减少网络请求次数
- 提高发送效率

## 错误处理和重试

SDK 内置了智能的错误处理和重试机制：

1. **持久化队列** - 失败的请求会保存到本地
2. **指数退避重试** - 使用指数退避算法
3. **应用重启恢复** - 应用重启后会自动发送之前失败的请求


## 数据安全

- **HTTPS 加密传输** - 所有数据通过 HTTPS 加密传输
- **本地存储安全** - 敏感数据存储在 UserDefaults 中

## 数据合规与 Opt-Out

SDK 提供合规采集开关，支持在运行时根据用户授权情况禁用全部数据采集。适用于 GDPR 等隐私合规场景：在取得用户授权前，或用户拒绝授权时，关闭采集。

### 配置选项

可以让 SDK 以默认禁用的状态启动，并可选地将用户的选择持久化、跨 App 重启保留：

```swift
let config = SensorswaveConfig()
config.optOutCapturing = true     // 默认禁用采集启动
config.persistOptOut = true       // 记住用户的选择，跨 App 重启保留
```

**Objective-C：**

```objc
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.optOutCapturing = YES;     // 默认禁用采集启动
config.persistOptOut = YES;       // 记住用户的选择，跨 App 重启保留
```

### 运行时 API

| 方法 | 说明 |
|------|------|
| `optOutCapturing()` | 立即禁用全部数据采集 |
| `optInCapturing()` | 恢复数据采集 |
| `hasOptedOutCapturing()` | 查询当前是否已禁用采集 |

```swift
// 禁用采集（例如用户拒绝授权）
Sensorswave.getInstance().optOutCapturing()

// 恢复采集（例如用户已授权）
Sensorswave.getInstance().optInCapturing()

// 查询当前状态
if Sensorswave.getInstance().hasOptedOutCapturing() {
    // 当前采集已禁用
}
```

**Objective-C：**

```objc
// 禁用采集
[[Sensorswave getInstance] optOutCapturing];

// 恢复采集
[[Sensorswave getInstance] optInCapturing];

// 查询当前状态
if ([[Sensorswave getInstance] hasOptedOutCapturing]) {
    // 当前采集已禁用
}
```

### 状态持久化

当 `persistOptOut = true` 时，授权状态会写入 UserDefaults，并在下次启动 App 时恢复，从而使用户的选择跨重启保留。`setup()` 时的初始状态按以下优先级判定：

1. 在 `setup()` **之前**显式调用 `optInCapturing()` / `optOutCapturing()`
2. 配置项 `optOutCapturing` 的值
3. UserDefaults 中持久化的值（仅当 `persistOptOut = true` 时生效）

## 常见问题

### 1. 如何启用调试模式？

```swift
let config = SensorswaveConfig()
config.debug = true
```

**Objective-C：**

```objc
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.debug = YES;
```

启用后会在控制台输出详细的日志信息，方便调试。

### 2. 如何追踪用户行为？

```swift
// 用户登录
Sensorswave.getInstance().identify(loginId: "user123")

// 追踪购买行为
Sensorswave.getInstance().trackEvent(eventName: "Purchase", properties: [
    "product_id": "12345",
    "amount": 99.99
])

// 设置用户属性
Sensorswave.getInstance().profileSet([
    "total_spent": 999.99,
    "purchase_count": 15
])
```

**Objective-C：**

```objc
// 用户登录
[[Sensorswave getInstance] identify:@"user123"];

// 追踪购买行为
[[Sensorswave getInstance] trackEvent:@"Purchase"
                                     properties:@{
                                         @"product_id": @"12345",
                                         @"amount": @99.99
                                     }];

// 设置用户属性
[[Sensorswave getInstance] profileSet:@{
    @"total_spent": @999.99,
    @"purchase_count": @15
}];
```

### 3. 如何使用 A/B 测试？

```swift
// 1. 启用 A/B 测试
config.enableAB = true

// 2. 检查功能开关
Sensorswave.getInstance().checkFeatureGate(key: "new_feature") { isEnabled in
    DispatchQueue.main.async {
        if isEnabled {
            self.enableNewFeature()
        }
    }
}

// 3. 获取实验配置
Sensorswave.getInstance().getExperiment(key: "pricing_display") { config in
    DispatchQueue.main.async {
        if let price = config["price"] as? Double {
            self.updatePrice(price)
        }
    }
}

// 4. 获取功能配置
Sensorswave.getInstance().getFeatureConfig(key: "app_settings") { config in
    DispatchQueue.main.async {
        if let dictConfig = config as? [String: Any], let theme = dictConfig["theme"] as? String {
            self.applyTheme(theme)
        }
    }
}
```

**Objective-C：**

```objc
// 1. 启用 A/B 测试
config.enableAB = YES;

// 2. 检查功能开关
[[Sensorswave getInstance] checkFeatureGate:@"new_feature" callback:^(BOOL isEnabled) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isEnabled) {
            [self enableNewFeature];
        }
    });
}];

// 3. 获取实验配置
[[Sensorswave getInstance] getExperiment:@"pricing_display" callback:^(NSDictionary<NSString *,id> *config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *price = config[@"price"];
        if (price) {
            [self updatePrice:[price doubleValue]];
        }
    });
}];

// 4. 获取功能配置
[[Sensorswave getInstance] getFeatureConfig:@"app_settings" callback:^(id config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([config isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictConfig = (NSDictionary *)config;
            NSString *theme = dictConfig[@"theme"];
            if (theme) {
                [self applyTheme:theme];
            }
        }
    });
}];
```

### 4. 如何处理网络失败？

SDK 会自动处理网络失败：
- 失败的请求会保存到本地队列
- 应用重启后会自动重试
- 使用指数退避策略避免服务器压力


### 5. 如何追踪页面浏览？

SDK 会自动追踪页面浏览（`autoCapture = true` 时），也可以手动追踪：

### 6. 如何清空用户数据？

```swift
// 删除用户属性
Sensorswave.getInstance().profileDelete()
```

**Objective-C：**

```objc
// 删除用户属性
[[Sensorswave getInstance] profileDelete];
```

## 最佳实践

### 1. 初始化时机

在 `application(_:didFinishLaunchingWithOptions:)` 中尽早初始化 SDK：

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 尽早初始化 SDK
    let config = SensorswaveConfig()
    config.debug = false
    config.apiHost = "https://api.example.com"

    Sensorswave.getInstance().setup(
        sourceToken: "your-source-token",
        config: config
    )

    return true
}
```

**Objective-C：**

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 尽早初始化 SDK
    SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
    config.debug = NO;
    config.apiHost = @"https://api.example.com";

    [[Sensorswave getInstance] setup:@"your-source-token" config:config];

    return YES;
}
```

### 2. 事件属性规范

**推荐做法：**

```swift
// ✅ 推荐：使用有意义的属性名
Sensorswave.getInstance().trackEvent(eventName: "ProductView", properties: [
    "product_id": "12345",
    "product_name": "iPhone 15 Pro",
    "category": "electronics",
    "price": 999.99,
    "in_stock": true
])

// ❌ 不推荐：属性名不明确
Sensorswave.getInstance().trackEvent(eventName: "Event", properties: [
    "data": "some data",
    "info": "test"
])
```

**Objective-C：**

```objc
// ✅ 推荐：使用有意义的属性名
[[Sensorswave getInstance] trackEvent:@"ProductView"
                                     properties:@{
                                         @"product_id": @"12345",
                                         @"product_name": @"iPhone 15 Pro",
                                         @"category": @"electronics",
                                         @"price": @999.99,
                                         @"in_stock": @YES
                                     }];

// ❌ 不推荐：属性名不明确
[[Sensorswave getInstance] trackEvent:@"Event"
                                     properties:@{
                                         @"data": @"some data",
                                         @"info": @"test"
                                     }];
```

**属性命名建议：**
- 使用蛇形命名（snake_case）：`button_name` 而不是 `buttonName`
- 使用有意义的名称：`product_id` 而不是 `id`
- 避免使用系统保留字（以 `$` 开头的属性）

### 3. 性能优化

```swift
// 生产环境配置
let config = SensorswaveConfig()
config.debug = false           // 关闭调试
config.batchSend = false         // 启用批量发送（默认关闭）
```

**Objective-C：**

```objc
// 生产环境配置
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.debug = NO;           // 关闭调试
config.batchSend = NO;         // 启用批量发送（默认关闭）
```

## 许可证

Apache-2.0
