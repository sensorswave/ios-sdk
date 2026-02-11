Pod::Spec.new do |s|
  s.name             = 'SensorswaveSDK'
  s.version          = '0.1.0'
  s.summary          = 'Sensorswave Analytics SDK for iOS'

  s.description      = <<-DESC
Sensorswave iOS SDK provides comprehensive analytics tracking,
A/B testing, and user behavior analysis for iOS applications.
Supports both Swift and Objective-C.

Core Features:
- Event tracking with custom properties
- User identification and profiling
- A/B testing with feature gates and experiments
- Automatic event collection (app lifecycle, page views, etc.)
- Persistent queue with offline support
- Plugin architecture for extensibility
                       DESC

  s.homepage         = 'https://sensorswave.com'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Sensorswave Team' => 'liulangyu@sensorsdata.com' }
  s.source           = { :git => 'https://github.com/sensorswave/ios-sdk.git', :tag => 'v' + s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.9'

  # Source files - include all Swift and header files
  s.vendored_frameworks = 'SensorswaveSDK/SensorswaveSDK.xcframework'

  # System frameworks
  s.frameworks = 'UIKit', 'Foundation', 'CoreTelephony'

  # Exclude test files
  s.exclude_files = 'SensorswaveSDKTests/**'

  # Pod target configuration
  s.pod_target_xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'DEFINES_MODULE' => 'YES'
  }
end
