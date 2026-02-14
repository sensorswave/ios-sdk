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
        config.abRefreshInterval = 5 * 60 * 1000  // 5 minute refresh interval
        config.batchSend = true                 // Enable batch sending

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

## Configuration Options

| Option | Type | Default | Description |
|---------|------|----------|-----------|
| `debug` | Bool | false | Enable debug mode for verbose logging |
| `apiHost` | String | '' | API server host for sending event data |
| `autoCapture` | Bool | true | Enable automatic event collection (page views, app starts, etc.) |
| `enableClickTrack` | Bool | false | Enable automatic click tracking |
| `enableAB` | Bool | false | Enable A/B testing functionality |
| `abRefreshInterval` | TimeInterval | 600000 (10 minutes) | A/B test config refresh interval (ms), minimum 30 seconds |
| `batchSend` | Bool | true | Enable batch sending (collect 10 events or send every 5 seconds) |

**Configuration Example:**

```swift
let config = SensorswaveConfig()
config.debug = true
config.apiHost = "https://api.example.com"
config.autoCapture = true
config.enableClickTrack = true
config.enableAB = true
config.abRefreshInterval = 5 * 60 * 1000  // 5 minutes
config.batchSend = true
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
    "login_id": "user@example.com"
])
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
    "email": "zhangsan@example.com",
    "age": 30,
    "plan": "premium"
])
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

#### profileDelete

Delete all user properties data. This operation cannot be undone.

**Parameters:** None

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().profileDelete()
```

### User Identification

#### identify

Set the current user's login ID and send a binding event ($Identify), associating anonymous behavior with the identified user.

**Parameters:**
- `loginId` (String, required): User's unique identifier (e.g., email, user ID, username)

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().identify(loginId: "user@example.com")
```

#### setLoginId

Set the current user's login ID, but does NOT send the binding event.

**Parameters:**
- `loginId` (String, required): User's unique identifier

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().setLoginId(loginId: "user@example.com")
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

**Note:** The iOS SDK currently only supports static properties. For dynamic properties, please update them before each event send.

#### clearCommonProperties

Clear specific registered common properties.

**Parameters:**
- `keys` ([String], required): Array of property keys to clear

**Returns:** None

**Example:**

```swift
Sensorswave.getInstance().clearCommonProperties(keys: ["app_version", "user_role"])
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

#### getExperiment

Get the current user's experiment configuration.

**Parameters:**
- `key` (String, required): Experiment key name
- `callback` ([String: Any]? -> Void, required): Callback function that returns experiment configuration

**Returns:** None

**Example:**

```swift
// Get experiment configuration
Sensorswave.getInstance().getExperiment(key: "homepage_layout") { config in
    DispatchQueue.main.async {
        guard let config = config else {
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

**Configuration Notes:**

A/B testing needs to be enabled first in the configuration:

```swift
config.enableAB = true
config.abRefreshInterval = 10 * 60 * 1000  // 10 minute refresh interval
```

## Automatic Events

When `autoCapture` is enabled, the SDK will automatically collect the following events:

- **$AppStart** - Application start event
- **$AppEnd** - Application end event
- **$AppInstall** - Application first install event (once only)
- **$AppPageView** - Page view event
- **$AppPageLeave** - Page leave event

When `enableClickTrack` is enabled, the SDK will also automatically collect:

- **$AppClick** - Click event

## Thread Safety

All SDK operations are thread-safe:

- **PersistentQueue** - Uses `NSLock` to protect all queue operations
- **Network Requests** - Supports multi-threaded concurrency
- **User Properties** - Uses synchronization mechanisms to ensure data consistency

## Batch Sending

Enabling batch sending can reduce the number of network requests and improve performance:

```swift
config.batchSend = true
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

## Common Issues

### 1. How to enable debug mode?

```swift
let config = SensorswaveConfig()
config.debug = true
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
        if let config = config,
           let price = config["price"] as? Double {
            self.updatePrice(price)
        }
    }
}
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

### 6. How to clear user data?

```swift
// Delete user properties
Sensorswave.getInstance().profileDelete()
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
    config.batchSend = true          // Enable batch sending

    Sensorswave.getInstance().setup(
        sourceToken: "your-source-token",
        config: config
    )

    return true
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

**Property Naming Guidelines:**
- Use snake_case naming: `button_name` not `buttonName`
- Use meaningful names: `product_id` not `id`
- Avoid system reserved words starting with `$`

### 3. Performance Optimization

```swift
// Production environment configuration
let config = SensorswaveConfig()
config.debug = false           // Disable debug
config.batchSend = true          // Enable batch sending
```

## License

Apache-2.0
