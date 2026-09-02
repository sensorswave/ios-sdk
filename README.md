# Sensors Wave iOS SDK

[Sensors Wave](https://sensorswave.com/) iOS SDK is a powerful mobile app analytics and A/B testing library designed for iOS applications.

## SDK Usage

### 1. Install SDK

#### CocoaPods Integration (Recommended）

Add to your `Podfile`:

```ruby
pod 'SensorswaveSDK'
```

Then run in terminal:

```bash
pod install
```

#### Manual Integration

1. Get the SDK binary from [GitHub](https://github.com/sensorswave/ios-sdk)
2. Drag the `SensorswaveSDK.xcframework` bundle into your Xcode project
3. Make sure to check "Copy items if needed"
4. Add the following frameworks to your project settings:
   - `Foundation.framework`
   - `UIKit.framework`
   - `CoreTelephony.framework`

### 2. Initialize SDK

Initialize the SDK in the `application(_:didFinishLaunchingWithOptions:)` method in `AppDelegate.swift`:

```swift
import UIKit
import SensorswaveSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Create configuration
        let config = SensorswaveConfig()
        config.debug = false                     // Disable debug in production
        config.apiHost = "https://api.example.com"  // Replace with your API Host
        config.autoCapture = true              // Enable automatic collection
        config.enableClickTrack = true           // Enable click tracking
        config.enableAB = true                  // Enable A/B testing
        config.enableCrashTrack = true           // Enable crash tracking (fatal)
        config.enableErrorTrack = true           // Enable error-level tracking
        config.abRefreshInterval = 5 * 60 * 1000  // 5 minute refresh interval
        config.batchSend = false                // Enable batch sending (disabled by default)

        // Initialize SDK
        Sensorswave.getInstance().setup(
            sourceToken: "your-source-token",  // Replace with your Source Token
            config: config
        )

        return true
    }
}
```

**Note:** Please replace `https://api.example.com` and `your-source-token` with your actual values.

#### Initialize SDK (Objective-C)

Initialize the SDK in the `application:didFinishLaunchingWithOptions:` method in `AppDelegate.m`:

```objc
#import <UIKit/UIKit.h>
#import <SensorswaveSDK/SensorswaveSDK-Swift.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Create configuration
    SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
    config.debug = NO;                     // Disable debug in production
    config.apiHost = @"https://api.example.com";  // Replace with your API Host
    config.autoCapture = YES;              // Enable automatic collection
    config.enableClickTrack = YES;         // Enable click tracking
    config.enableAB = YES;                 // Enable A/B testing
    config.enableCrashTrack = YES;         // Enable crash tracking (fatal)
    config.enableErrorTrack = YES;         // Enable error-level tracking
    config.abRefreshInterval = 5 * 60 * 1000;  // 5 minute refresh interval
    config.batchSend = NO;                // Enable batch sending (disabled by default)

    // Initialize SDK
    [[Sensorswave getInstance] setup:@"your-source-token" config:config];

    return YES;
}

@end
```

### 3. Track Custom Events

```swift
// Track simple event
Sensorswave.getInstance().trackEvent(eventName: "button_click")

// Track event with properties
Sensorswave.getInstance().trackEvent(eventName: "button_click", properties: [
    "buttonName": "submit",
    "page": "home",
    "category": "user_action"
])
```

```objc
// Track simple event
[[Sensorswave getInstance] trackEvent:@"button_click" properties:nil];

// Track event with properties
[[Sensorswave getInstance] trackEvent:@"button_click"
                                     properties:@{
                                         @"buttonName": @"submit",
                                         @"page": @"home",
                                         @"category": @"user_action"
                                     }];
```

## Configuration Options

| Option | Type | Default | Description |
|---------|------|----------|-----------|
| `debug` | Bool | false | Enable debug mode for verbose logging |
| `apiHost` | String | '' | API server host for sending event data |
| `autoCapture` | Bool | true | Enable automatic event collection (page views, app starts, etc.) |
| `enableClickTrack` | Bool | false | Enable automatic click tracking |
| `enableAB` | Bool | false | Enable A/B testing functionality |
| `enableCrashTrack` | Bool | false | Enable crash tracking (fatal `$Exception` events). Independent of `autoCapture`. Reports are sent on the next launch after a crash. Not installed while a debugger is attached |
| `enableErrorTrack` | Bool | false | Enable error-level collection (enables the manual `trackException` API). Independent of `autoCapture` |
| `abRefreshInterval` | TimeInterval | 600000 (10 minutes) | A/B test config refresh interval (ms), minimum 30 seconds |
| `batchSend` | Bool | false | Enable batch sending (collect 10 events or send every 5 seconds) |
| `optOutCapturing` | Bool | false | Disable data collection by default (compliance switch). The SDK will not collect, send, or persist any events |
| `persistOptOut` | Bool | false | Persist the opt-out consent state across app restarts via UserDefaults |

**Configuration Example:**

```swift
let config = SensorswaveConfig()
config.debug = true
config.apiHost = "https://api.example.com"
config.autoCapture = true
config.enableClickTrack = true
config.enableAB = true
config.enableCrashTrack = true
config.enableErrorTrack = true
config.abRefreshInterval = 5 * 60 * 1000  // 5 minutes
config.batchSend = false  // Disabled by default, set to true to enable
```

```objc
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.debug = YES;
config.apiHost = @"https://api.example.com";
config.autoCapture = YES;
config.enableClickTrack = YES;
config.enableAB = YES;
config.enableCrashTrack = YES;
config.enableErrorTrack = YES;
config.abRefreshInterval = 5 * 60 * 1000;  // 5 minutes
config.batchSend = NO;  // Disabled by default, set to YES to enable
```

## API Methods

### Event Tracking

#### trackEvent

Manually track custom events.

**Parameters:**
- `eventName` (String, required): Name of the event to track
- `properties` (Dictionary<String, Any>, optional): Event properties

**Returns:** None

**Example:**

```swift
// Simple event
Sensorswave.getInstance().trackEvent(eventName: "user_login")

// Event with properties
Sensorswave.getInstance().trackEvent(eventName: "purchase_completed", properties: [
    "product_id": "12345",
    "amount": 99.99,
    "currency": "USD",
    "category": "ecommerce"
])
```

```objc
// Simple event
[[Sensorswave getInstance] trackEvent:@"user_login" properties:nil];

// Event with properties
[[Sensorswave getInstance] trackEvent:@"purchase_completed"
                                     properties:@{
                                         @"product_id": @"12345",
                                         @"amount": @99.99,
                                         @"currency": @"USD",
                                         @"category": @"ecommerce"
                                     }];
```

#### track

Track complete event object (advanced method).

**Parameters:**
- `event` (AdvancedEvent, required): Complete event object with the following fields:
  - `event` (string, required): Event name
  - `properties` (Dictionary<string, any>, optional): Event properties
  - `time` (number, required): Timestamp in milliseconds
  - `anon_id` (string, optional): Anonymous user ID
  - `login_id` (string, optional): Logged-in user ID. Either `login_id` or `anon_id` must be provided, with `login_id` taking priority when both are present
  - `trace_id` (string, required): Request tracking ID
  - `user_properties` (Dictionary<string, any>, optional): User properties
  - `subject_properties` (Dictionary<string, any>, optional): Subject properties

**Returns:** None

**Example:**

```swift
// Using complete event object
Sensorswave.getInstance().track(event: [
    "event": "custom_event",
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
// Using complete event object
[[Sensorswave getInstance] track:@{
    @"event": @"custom_event",
    @"properties": @{
        @"key1": @"value1",
        @"key2": @"value2"
    },
    @"time": @([[NSDate date] timeIntervalSince1970] * 1000),
    @"trace_id": [[NSUUID UUID] UUIDString],
    @"login_id": @"user_12345"
}];
```

### User Properties

#### profileSet

Set user properties. If a property already exists, it will be overwritten.

**Parameters:**
- `properties` (Dictionary<String, Any>, required): User properties to set

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().profileSet([
    "name": "Zhang San",
    "age": 30,
    "plan": "premium"
])
```

```objc
[[Sensorswave getInstance] profileSet:@{
    @"name": @"Zhang San",
    @"age": @30,
    @"plan": @"premium"
}];
```

#### profileSetOnce

Set one-time user properties. If a property doesn't exist, it will be set. If it already exists, it will be ignored.

**Parameters:**
- `properties` (Dictionary<String, Any>, required): User properties to set

**Returns:** None

**Example:**

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

Increment numeric type user properties. Only supports numeric type properties.

**Parameters:**
- `properties` (Dictionary<String, Any>, required): Properties to increment, values must be numbers

**Returns:** None

**Example:**

```swift
// Increment single property
Sensorswave.getInstance().profileIncrement(properties: [
    "login_count": 1
])

// Increment multiple properties
Sensorswave.getInstance().profileIncrement(properties: [
    "login_count": 1,
    "points_earned": 100,
    "purchases_count": 1
])
```

```objc
// Increment single property
[[Sensorswave getInstance] profileIncrement:@{@"login_count": @1}];

// Increment multiple properties
[[Sensorswave getInstance] profileIncrement:@{
    @"login_count": @1,
    @"points_earned": @100,
    @"purchases_count": @1
}];
```

#### profileAppend

Append values to list-type user properties. Does NOT remove duplicates.

**Parameters:**
- `properties` (Dictionary<String, Any>, required): Properties to append, values must be arrays

**Returns:** None

**Example:**

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

Append values to list-type user properties. DOES remove duplicates.

**Parameters:**
- `properties` (Dictionary<String, Any>, required): Properties to append, values must be arrays

**Returns:** None

**Example:**

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

Clear specific user properties (set to null).

**Parameters:**
- `key` (String, required): Single property key to clear
- `keys` ([String], required): Multiple property keys to clear

**Returns:** None

**Example:**

```swift
// Clear single property
Sensorswave.getInstance().profileUnset(key: "temporary_campaign")

// Clear multiple properties
Sensorswave.getInstance().profileUnset(keys: ["old_plan", "expired_flag", "temp_id"])
```

```objc
// Clear single property
[[Sensorswave getInstance] profileUnsetKey:@"temporary_campaign"];

// Clear multiple properties
[[Sensorswave getInstance] profileUnsetKeys:@[@"old_plan", @"expired_flag", @"temp_id"]];
```

#### profileDelete

Delete all user properties data. This operation cannot be undone.

**Parameters:** None

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().profileDelete()
```

```objc
[[Sensorswave getInstance] profileDelete];
```

### User Identification

#### identify

Set the current user's login ID and send a binding event ($Identify), associating anonymous behavior with the identified user.

**Parameters:**
- `loginId` (String, required): User's unique identifier (e.g., email, user ID, username)

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().identify(loginId: "user_12345")
```

```objc
[[Sensorswave getInstance] identify:@"user_12345"];
```

#### setLoginId

Set the current user's login ID, but does NOT send the binding event.

**Parameters:**
- `loginId` (String, required): User's unique identifier

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().setLoginId(loginId: "user_12345")
```

```objc
[[Sensorswave getInstance] setLoginId:@"user_12345"];
```

#### reset

Called when the user logs out. Unbinds the login ID from the device. By default the anonymous ID is preserved, so subsequent events are attributed to the same anonymous ID.

**Parameters:**
- `resetAnonId` (Bool, optional): Pass `true` to also reset the anonymous ID and generate a new one (e.g., for shared/public devices). Defaults to `false`.

**Returns:** None

**Example:**

```swift
// On user logout (keeps the anonymous ID)
Sensorswave.getInstance().reset()

// Also reset the anonymous ID (e.g., shared device scenario)
Sensorswave.getInstance().reset(true)
```

```objc
// On user logout (keeps the anonymous ID)
[[Sensorswave getInstance] reset:NO];

// Also reset the anonymous ID (e.g., shared device scenario)
[[Sensorswave getInstance] reset:YES];
```

#### getLoginId

Get the current user's login ID. Returns an empty string if the user is not logged in (i.e., no login ID has been set via `identify` or `setLoginId`).

**Parameters:** None

**Returns:** `String` - The current login ID, or an empty string if not set

**Example:**

```swift
let loginId = Sensorswave.getInstance().getLoginId()
if loginId.isEmpty {
    // User is not logged in
} else {
    // Use loginId
}
```

```objc
NSString *loginId = [[Sensorswave getInstance] getLoginId];
if (loginId.length == 0) {
    // User is not logged in
} else {
    // Use loginId
}
```

#### getAnonId

Get the current device's anonymous ID. The anonymous ID is generated on first access and persisted, so this method always returns a non-empty string.

**Parameters:** None

**Returns:** `String` - The anonymous ID (always non-empty)

**Example:**

```swift
let anonId = Sensorswave.getInstance().getAnonId()
```

```objc
NSString *anonId = [[Sensorswave getInstance] getAnonId];
```

### Common Properties

#### registerCommonProperties

Register common properties that will be included in all events.

**Parameters:**
- `properties` (Dictionary<String, Any>, required): Properties to register

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().registerCommonProperties(properties: [
    // Static properties
    "app_version": "1.0.0",
    "environment": "production",
    "user_role": "guest"
])
```

```objc
[[Sensorswave getInstance] registerCommonProperties:@{
    // Static properties
    @"app_version": @"1.0.0",
    @"environment": @"production",
    @"user_role": @"guest"
}];
```

**Dynamic properties:** wrap a value in `SWDynamicProperty` to have it re-evaluated on every event send (instead of a snapshot at registration time). Suitable for frequently changing values such as timestamps, balances, or page context.

```swift
Sensorswave.getInstance().registerCommonProperties(properties: [
    "app_version": "1.0.0",                       // Static: snapshot at registration
    "current_time": SWDynamicProperty {           // Dynamic: evaluated per event
        Int64(Date().timeIntervalSince1970 * 1000)
    }
])
```

```objc
[[Sensorswave getInstance] registerCommonProperties:@{
    @"app_version": @"1.0.0",
    @"current_time": [[SWDynamicProperty alloc] initWithClosure:^id{
        return @((long long)([[NSDate date] timeIntervalSince1970] * 1000));
    }]
}];
```

**Notes on dynamic properties:**
- The closure runs synchronously on the event-sending path (caller thread); keep it fast and non-blocking.
- Returning `nil` omits the key for that event (conditional properties).
- Values must be JSON-serializable. Unserializable values (e.g. `Date`, `URL`, raw closures) are dropped with a warning — they never break the event itself. Convert dates to millisecond timestamps or ISO-8601 strings.
- `SWDynamicProperty` only takes effect as the top-level value of a key; nested occurrences inside arrays/dictionaries are not evaluated.
- The SDK does not catch exceptions or crashes thrown inside the closure.

#### clearCommonProperties

Clear specific registered common properties.

**Parameters:**
- `keys` ([String], required): Array of property keys to clear

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().clearCommonProperties(keys: ["app_version", "user_role"])
```

```objc
[[Sensorswave getInstance] clearCommonProperties:@[@"app_version", @"user_role"]];
```

### A/B Testing

#### checkFeatureGate

Check if a feature gate (Feature Flag) is enabled for the current user.

**Parameters:**
- `key` (String, required): Feature gate key name
- `callback` (Bool -> Void, required): Callback function that returns feature gate status

**Returns:** None

**Example:**

```swift
// Check feature gate
Sensorswave.getInstance().checkFeatureGate(key: "new_checkout_flow") { isEnabled in
    DispatchQueue.main.async {
        if isEnabled {
            // Enable new feature
            self.showNewCheckout()
        } else {
            // Use old feature
            self.showOldCheckout()
        }
    }
}
```

```objc
// Check feature gate
[[Sensorswave getInstance] checkFeatureGate:@"new_checkout_flow" callback:^(BOOL isEnabled) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isEnabled) {
            // Enable new feature
            [self showNewCheckout];
        } else {
            // Use old feature
            [self showOldCheckout];
        }
    });
}];
```

#### getExperiment

Get the current user's experiment configuration.

**Parameters:**
- `key` (String, required): Experiment key name
- `callback` ([String: Any] -> Void, required): Callback function that returns experiment configuration

**Returns:** None

**Example:**

```swift
// Get experiment configuration
Sensorswave.getInstance().getExperiment(key: "homepage_layout") { config in
    DispatchQueue.main.async {
        if config.isEmpty {
            // Default configuration
            self.applyDefaultLayout()
            return
        }

        // Apply experiment configuration
        if let layoutType = config["layout_type"] as? String {
            self.applyLayout(layoutType)
        }
    }
}
```

```objc
// Get experiment configuration
[[Sensorswave getInstance] getExperiment:@"homepage_layout" callback:^(NSDictionary<NSString *,id> *config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (config.count > 0) {
            // Apply experiment configuration
            NSString *layoutType = config[@"layout_type"];
            [self applyLayout:layoutType];
        } else {
            // Default configuration
            [self applyDefaultLayout];
        }
    });
}];
```

#### getFeatureConfig

Get the current user's feature configuration (returns dynamic type).

**Parameters:**
- `key` (String, required): Feature configuration key name
- `callback` (Any -> Void, required): Callback function that returns feature configuration

**Returns:** None

**Example:**

```swift
// Get feature configuration
Sensorswave.getInstance().getFeatureConfig(key: "app_settings") { config in
    DispatchQueue.main.async {
        // Handle different return types
        if let dictConfig = config as? [String: Any] {
            // JSON object: {"theme": "dark", "max_size": 100}
            if let theme = dictConfig["theme"] as? String {
                self.applyTheme(theme)
            }
            if let maxSize = dictConfig["max_size"] as? Int {
                self.updateMaxSize(maxSize)
            }
        } else if let stringConfig = config as? String {
            // Raw string value
            self.applyRawConfig(stringConfig)
        } else if let dictConfig = config as? [String: Any], dictConfig.isEmpty {
            // Empty config - use defaults
            self.applyDefaultConfig()
        }
    }
}
```

```objc
// Get feature configuration
[[Sensorswave getInstance] getFeatureConfig:@"app_settings" callback:^(id config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([config isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictConfig = (NSDictionary *)config;
            if (dictConfig.count > 0) {
                // Apply feature configuration
                NSString *theme = dictConfig[@"theme"];
                NSNumber *maxSize = dictConfig[@"max_size"];
                [self applyTheme:theme];
                [self updateMaxSize:[maxSize integerValue]];
            } else {
                // Empty config - use defaults
                [self applyDefaultConfig];
            }
        } else if ([config isKindOfClass:[NSString class]]) {
            // Raw string value
            NSString *stringConfig = (NSString *)config;
            [self applyRawConfig:stringConfig];
        }
    });
}];
```

**Note:** This method returns a dynamic type (`Any`). The value from server may be a JSON string that will be automatically parsed to a dictionary. If parsing fails, the raw value (string) is returned. If the config is not found, an empty dictionary is returned.

**Configuration Notes:**

A/B testing needs to be enabled first in the configuration:

```swift
config.enableAB = true
config.abRefreshInterval = 10 * 60 * 1000  // 10 minute refresh interval
```

**Configuration Notes (Objective-C):**

```objc
config.enableAB = YES;
config.abRefreshInterval = 10 * 60 * 1000;  // 10 minute refresh interval
```

## Exception Tracking

The SDK reports exceptions via the preset `$Exception` event, which has the following properties:

| Property | Type | Description |
|---|---|---|
| `$exception_level` | String | `"fatal"` (uncaught exception/signal terminated the process) or `"error"` (a caught error, reported manually) |
| `$exception_type` | String | Exception class name, e.g. `NSRangeException`, `SIGSEGV`, or an NSError domain |
| `$exception_message` | String | Message only, no stack |
| `$exception_frames` | Array&lt;Object&gt; | Structured stack frames (unified multi-platform format, max 30 frames). Each frame has `platform` (`ios`), `module` (binary image), `function` and `instruction_addr` (absolute runtime address, PAC-stripped, 16-digit zero-padded hex); frames that resolve to an image also carry `image_addr` (image load address), `debug_id` (Mach-O UUID, uppercase hyphenated) and `in_app`; `filename`/`lineno`/`colno` are included only when debug symbols provide them |

**Server-side symbolication (dSYM)**: frames are self-contained — match the uploaded dSYM by `debug_id`, then `atos -arch arm64 -o <dSYM/DWARF/binary> -l <image_addr> <instruction_addr>` resolves file:line (offset = `instruction_addr - image_addr`; both are captured together — for fatal crashes, at crash time). ASLR changes every launch, so `image_addr` must never be recomputed across launches.

Two independent switches control exception tracking (both default to `false` and neither is affected by `autoCapture`):

```swift
config.enableCrashTrack = true  // fatal: uncaught NSException + fatal signals (SIGABRT/SIGSEGV/SIGFPE/SIGBUS/SIGILL/SIGTRAP, covering Swift fatalError)
config.enableErrorTrack = true  // error: enables the manual trackException API
```

```objc
config.enableCrashTrack = YES;
config.enableErrorTrack = YES;
```

### Manual Error Reporting

Use `trackException` to report errors you have already caught (requires `enableErrorTrack = true`):

```swift
// Swift Error (or NSError)
Sensorswave.getInstance().trackException(
    NSError(domain: "com.example.app", code: -1009,
            userInfo: [NSLocalizedDescriptionKey: "Network unavailable"]),
    properties: ["scene": "checkout"]
)

// NSException
Sensorswave.getInstance().trackException(
    NSException(name: NSExceptionName("NSRangeException"),
                reason: "index 5 beyond bounds", userInfo: nil)
)
```

```objc
// NSError: trackExceptionError:properties:
[[Sensorswave getInstance] trackExceptionError:error properties:@{@"scene": @"checkout"}];

// NSException: trackException:properties:
[[Sensorswave getInstance] trackException:exception properties:nil];
```

Custom `properties` are merged into the event and reported with level `"error"`.

### Crash Reporting Behavior (fatal)

- Crash reports (uncaught `NSException` and fatal signals) are written synchronously to disk when the crash occurs, then reported as `$Exception` with level `"fatal"` **on the next app launch**, using the crash timestamp as the event `time`. Failed sends are retried through the SDK's existing queue/retry mechanism.
- Crash handlers are **not installed while a debugger is attached** (to avoid interfering with breakpoints). To verify crash reporting, run the app without Xcode attached (e.g. launch it directly from the home screen).
- If the user has opted out (`optOutCapturing`), pending crash reports are deleted without being sent.
- Existing crash handlers installed by other SDKs are preserved and chained.

## Automatic Events

When `autoCapture` is enabled, the SDK will automatically collect the following events:

- **$AppStart** - Application start event
- **$AppEnd** - Application end event
- **$AppInstall** - Application first install event (once only)
- **$AppPageView** - Page view event
- **$AppPageLeave** - Page leave event

When `enableClickTrack` is enabled, the SDK will also automatically collect:

- **$AppClick** - Click event

When `enableCrashTrack` / `enableErrorTrack` are enabled, the SDK also collects **$Exception** events (see [Exception Tracking](#exception-tracking)).

## Thread Safety

All SDK operations are thread-safe:

- **PersistentQueue** - Uses `NSLock` to protect all queue operations
- **Network Requests** - Supports multi-threaded concurrency
- **User Properties** - Uses synchronization mechanisms to ensure data consistency

## Batch Sending

Enabling batch sending can reduce the number of network requests and improve performance:

```swift
config.batchSend = true  // Disabled by default
```

**Objective-C:**

```objc
config.batchSend = YES;  // Disabled by default
```

**Batch Sending Behavior:**
- Collect 10 events then send immediately
- Or send every 5 seconds
- Uses thread-safe queue management

**Benefits:**
- Reduce network requests
- Save battery consumption
- Improve sending efficiency

## Error Handling and Retry

The SDK has built-in intelligent error handling and retry mechanisms:

1. **Persistent Queue** - Failed requests are saved locally
2. **Exponential Backoff** - Uses exponential backoff algorithm to avoid server pressure
3. **App Restart Recovery** - Automatically retries failed requests after app restart

## Data Security

- **HTTPS Encrypted Transfer** - All data is transmitted via HTTPS encryption
- **Local Storage Security** - Sensitive data is stored in UserDefaults

## Data Privacy & Opt-Out

The SDK provides compliance controls that let you respect user consent and disable all data collection at runtime. This is useful for GDPR / privacy regulations where you must wait for — or honor a refusal of — user consent.

### Configuration

You can start the SDK in a fully disabled state and optionally remember the user's choice across app restarts:

```swift
let config = SensorswaveConfig()
config.optOutCapturing = true     // Start with collection disabled
config.persistOptOut = true       // Remember the choice across app restarts
```

**Objective-C:**

```objc
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.optOutCapturing = YES;     // Start with collection disabled
config.persistOptOut = YES;       // Remember the choice across app restarts
```

### Runtime API

| Method | Description |
|--------|-------------|
| `optOutCapturing()` | Disable all data collection immediately |
| `optInCapturing()` | Re-enable data collection |
| `hasOptedOutCapturing()` | Returns whether collection is currently disabled |

```swift
// Disable collection (e.g., user declined consent)
Sensorswave.getInstance().optOutCapturing()

// Re-enable collection (e.g., user granted consent)
Sensorswave.getInstance().optInCapturing()

// Check the current state
if Sensorswave.getInstance().hasOptedOutCapturing() {
    // Collection is disabled
}
```

**Objective-C:**

```objc
// Disable collection
[[Sensorswave getInstance] optOutCapturing];

// Re-enable collection
[[Sensorswave getInstance] optInCapturing];

// Check the current state
if ([[Sensorswave getInstance] hasOptedOutCapturing]) {
    // Collection is disabled
}
```

### State persistence

When `persistOptOut = true`, the consent state is written to UserDefaults and restored on the next app launch, so the user's choice survives restarts. On `setup()`, the initial state is resolved with this priority:

1. An explicit `optInCapturing()` / `optOutCapturing()` call made **before** `setup()`
2. The `optOutCapturing` config value
3. The persisted value from UserDefaults (only when `persistOptOut = true`)

## Common Issues

### 1. How to enable debug mode?

```swift
let config = SensorswaveConfig()
config.debug = true
```

**Objective-C:**

```objc
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.debug = YES;
```

When enabled, detailed log information will be output to console for debugging.

### 2. How to track user behavior?

```swift
// User login
Sensorswave.getInstance().identify(loginId: "user123")

// Track purchase behavior
Sensorswave.getInstance().trackEvent(eventName: "purchase", properties: [
    "product_id": "12345",
    "amount": 99.99
])

// Set user properties
Sensorswave.getInstance().profileSet([
    "total_spent": 999.99,
    "purchase_count": 15
])
```

**Objective-C:**

```objc
// User login
[[Sensorswave getInstance] identify:@"user123"];

// Track purchase behavior
[[Sensorswave getInstance] trackEvent:@"purchase"
                                     properties:@{
                                         @"product_id": @"12345",
                                         @"amount": @99.99
                                     }];

// Set user properties
[[Sensorswave getInstance] profileSet:@{
    @"total_spent": @999.99,
    @"purchase_count": @15
}];
```

### 3. How to use A/B testing?

```swift
// 1. Enable A/B testing
config.enableAB = true

// 2. Check feature gate
Sensorswave.getInstance().checkFeatureGate(key: "new_feature") { isEnabled in
    DispatchQueue.main.async {
        if isEnabled {
            self.enableNewFeature()
        }
    }
}

// 3. Get experiment configuration
Sensorswave.getInstance().getExperiment(key: "pricing_display") { config in
    DispatchQueue.main.async {
        if let price = config["price"] as? Double {
            self.updatePrice(price)
        }
    }
}

// 4. Get feature configuration
Sensorswave.getInstance().getFeatureConfig(key: "app_settings") { config in
    DispatchQueue.main.async {
        if let dictConfig = config as? [String: Any], let theme = dictConfig["theme"] as? String {
            self.applyTheme(theme)
        }
    }
}
```

**Objective-C:**

```objc
// 1. Enable A/B testing
config.enableAB = YES;

// 2. Check feature gate
[[Sensorswave getInstance] checkFeatureGate:@"new_feature" callback:^(BOOL isEnabled) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isEnabled) {
            [self enableNewFeature];
        }
    });
}];

// 3. Get experiment configuration
[[Sensorswave getInstance] getExperiment:@"pricing_display" callback:^(NSDictionary<NSString *,id> *config) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *price = config[@"price"];
        if (price) {
            [self updatePrice:[price doubleValue]];
        }
    });
}];

// 4. Get feature configuration
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

### 4. How to handle network failures?

The SDK automatically handles network failures:

- Failed requests are saved to local queue
- Automatically retries after app restart
- Uses exponential backoff strategy to avoid server pressure

### 5. How to track page views?

The SDK automatically tracks page views when `autoCapture = true`. You can also manually track:

```swift
// Set current page title
Sensorswave.getInstance().setCurrentPageTitle("Product Details")

// SDK will automatically send $AppPageView event
```

**Objective-C:**

```objc
// Set current page title
[[Sensorswave getInstance] setCurrentPageTitle:@"Product Details"];

// SDK will automatically send $AppPageView event
```

### 6. How to clear user data?

```swift
// Delete user properties
Sensorswave.getInstance().profileDelete()
```

**Objective-C:**

```objc
// Delete user properties
[[Sensorswave getInstance] profileDelete];
```

## Best Practices

### 1. Initialization Timing

Initialize the SDK as early as possible in `application(_:didFinishLaunchingWithOptions:)`:

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initialize SDK as early as possible
    let config = SensorswaveConfig()
    config.debug = false           // Disable debug in production
    config.apiHost = "https://api.example.com"
    config.batchSend = true          // Enable batch sending (disabled by default)

    Sensorswave.getInstance().setup(
        sourceToken: "your-source-token",
        config: config
    )

    return true
}
```

**Objective-C:**

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize SDK as early as possible
    SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
    config.debug = NO;           // Disable debug in production
    config.apiHost = @"https://api.example.com";
    config.batchSend = YES;       // Enable batch sending (disabled by default)

    [[Sensorswave getInstance] setup:@"your-source-token" config:config];

    return YES;
}
```

### 2. Event Property Guidelines

**Recommended:**

```swift
// ✅ Recommended: Use meaningful property names
Sensorswave.getInstance().trackEvent(eventName: "product_view", properties: [
    "product_id": "12345",
    "product_name": "iPhone 15 Pro",
    "category": "electronics",
    "price": 999.99,
    "in_stock": true
])

// ❌ Not Recommended: Property name unclear
Sensorswave.getInstance().trackEvent(eventName: "event", properties: [
    "data": "some data",
    "info": "test"
])
```

**Objective-C:**

```objc
// ✅ Recommended: Use meaningful property names
[[Sensorswave getInstance] trackEvent:@"product_view"
                                     properties:@{
                                         @"product_id": @"12345",
                                         @"product_name": @"iPhone 15 Pro",
                                         @"category": @"electronics",
                                         @"price": @999.99,
                                         @"in_stock": @YES
                                     }];

// ❌ Not Recommended: Property name unclear
[[Sensorswave getInstance] trackEvent:@"event"
                                     properties:@{
                                         @"data": @"some data",
                                         @"info": @"test"
                                     }];
```

**Property Naming Guidelines:**
- Use snake_case naming: `button_name` not `buttonName`
- Use meaningful names: `product_id` not `id`
- Avoid system reserved words starting with `$`

### 3. Performance Optimization

```swift
// Production environment configuration
let config = SensorswaveConfig()
config.debug = false           // Disable debug
config.batchSend = true          // Enable batch sending (disabled by default)
```

**Objective-C:**

```objc
// Production environment configuration
SensorswaveConfig *config = [[SensorswaveConfig alloc] init];
config.debug = NO;           // Disable debug
config.batchSend = YES;       // Enable batch sending (disabled by default)
```

## License

Apache-2.0
