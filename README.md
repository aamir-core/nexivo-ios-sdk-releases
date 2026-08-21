# Nexivo Widget SDK — iOS

A plug-and-play customer support call/chat widget for iOS. Provides a floating button that opens a native modal with agent card, phone/OTP verification (or SSO via `APP_CONNECT`), and live voice/video calling via LiveKit.

---

## Requirements

| Requirement | Minimum  |
|-------------|----------|
| iOS         | 15+      |
| Xcode       | 15+      |
| Swift       | 5.9+     |

---

<details>
<summary><strong>Native iOS Integration</strong></summary>

<br>

### 1. Add the SDK package in Xcode

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the package URL:
   ```
   https://github.com/aamir-core/nexivo-ios-sdk-releases
   ```
3. Select **Up to Next Major Version** from `1.1.2`
4. Click **Add Package**
5. Add **NexivoWidget** to your app target

---

### 2. Info.plist Permissions

Add these keys to your app's `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Nexivo needs microphone access for voice calls.</string>
<key>NSCameraUsageDescription</key>
<string>Nexivo needs camera access for video calls.</string>
```

---

### 3. Usage

#### OTP auth (default)

```swift
import NexivoWidgetCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let window = UIApplication.shared.windows.first else { return true }

        NexivoWidget.shared.initialize(
            tenantId: "your-tenant-id",
            widgetId: "your-widget-id",
            // baseUrl: "https://your-base-url.com",  // optional
            in: window
        ) { event in
            // event.action     → "CALL_INITIATED" | "CALL_RINGING" | "CALL_PICKED_UP" | "CALL_ENDED"
            // event.agentName  → display name of the agent
            // event.userId     → resolved Contact ID (available after auth)
            // event.token      → session token (available after auth)
            print("NexivoEvent: \(event.action) — \(event.agentName)")
        }

        NexivoWidget.shared.show()
        return true
    }
}
```

#### SSO auth (`APP_CONNECT`)

> **Prerequisite:** the widget must be configured with `providerType: "APP_CONNECT"` on the Nexivo server side. Contact the Nexivo team to enable this for your widget.

When `APP_CONNECT` is enabled, the OTP / phone-number screen is skipped entirely. Call `setToken()` with your backend-issued JWT as soon as it is available. The SDK buffers the token internally — it is safe to call `setToken()` before `initialize()` completes.

```swift
NexivoWidget.shared.initialize(tenantId: "your-tenant-id", widgetId: "your-widget-id", in: window) { event in
    print("NexivoEvent: \(event.action)")
}

// Safe to call right away — token is buffered until config fetch completes
NexivoWidget.shared.setToken("jwt-from-your-backend")
NexivoWidget.shared.show()
```

The widget exchanges the JWT for a Nexivo session token automatically and loads the user's details.

---

### API Reference

| Method | Description |
|--------|-------------|
| `NexivoWidget.shared.initialize(tenantId:widgetId:baseUrl:in:onEvent:)` | Initialise the SDK. Fetches widget config from the server. `baseUrl` defaults to `https://widget.nexivo.dev.cognitry.io`. |
| `NexivoWidget.shared.setToken(_:)` | Attach a JWT for `APP_CONNECT` SSO auth. Call after `initialize()` and after your user logs in. |
| `NexivoWidget.shared.show()` | Make the floating button visible. |
| `NexivoWidget.shared.hide()` | Hide the floating button. |
| `NexivoWidget.shared.destroy()` | Remove the widget and release resources. |

---

### Event Reference

| Field        | Type      | Description                                      |
|--------------|-----------|--------------------------------------------------|
| `action`     | `String`  | One of `CALL_INITIATED`, `CALL_RINGING`, `CALL_PICKED_UP`, `CALL_ENDED` |
| `agentName`  | `String`  | Display name of the agent                        |
| `userId`     | `String?` | Resolved Contact ID in the Nexivo system (set after auth) |
| `token`      | `String?` | Session token (set after auth)                   |
| `timestamp`  | `Date`    | Event timestamp                                  |

---

## Credentials

Contact the Nexivo team to obtain your `tenantId` and `widgetId`.

</details>

---

<details>
<summary><strong>React Native Integration</strong></summary>

<br>

### 1. Add the SDK package in Xcode

1. Open your React Native project's `.xcworkspace` in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter:
   ```
   https://github.com/aamir-core/nexivo-ios-sdk-releases
   ```
4. Select **Up to Next Major Version** from `1.1.2`
5. Click **Add Package**
6. Add **NexivoWidget** to your app target

---

### 2. Info.plist Permissions

Add these keys to your app's `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Nexivo needs microphone access for voice calls.</string>
<key>NSCameraUsageDescription</key>
<string>Nexivo needs camera access for video calls.</string>
```

---

### 3. Create `NexivoWidgetModule.m`

Create this file inside `ios/YourApp/`:

```objc
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_REMAP_MODULE(NexivoWidget, NexivoWidgetModule, RCTEventEmitter)

RCT_EXTERN_METHOD(initWidget:(NSString *)tenantId widgetId:(NSString *)widgetId baseUrl:(NSString *)baseUrl)
RCT_EXTERN_METHOD(setToken:(NSString *)token)
RCT_EXTERN_METHOD(show)
RCT_EXTERN_METHOD(hide)
RCT_EXTERN_METHOD(destroy)

@end
```

---

### 4. Create `NexivoWidgetModule.swift`

Create this file inside `ios/YourApp/`:

```swift
import UIKit
import React
import NexivoWidgetCore

@objc(NexivoWidgetModule)
final class NexivoWidgetModule: RCTEventEmitter {

    private var hasListeners = false

    override static func requiresMainQueueSetup() -> Bool { true }
    override func supportedEvents() -> [String]! { ["NexivoEvent"] }
    override func startObserving() { hasListeners = true }
    override func stopObserving()  { hasListeners = false }

    @objc(initWidget:widgetId:baseUrl:)
    func initWidget(_ tenantId: String, widgetId: String, baseUrl: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self, let window = Self.keyWindow() else { return }
            NexivoWidget.shared.initialize(
                tenantId: tenantId,
                widgetId: widgetId,
                baseUrl:  baseUrl,
                in:       window
            ) { [weak self] event in
                guard let self, self.hasListeners else { return }
                self.sendEvent(withName: "NexivoEvent", body: [
                    "action":    event.action,
                    "agentName": event.agentName,
                    "userId":    event.userId as Any,
                    "token":     event.token  as Any,
                    "timestamp": event.timestamp.timeIntervalSince1970 * 1000
                ])
            }
        }
    }

    @objc func setToken(_ token: String) {
        DispatchQueue.main.async { NexivoWidget.shared.setToken(token) }
    }

    @objc func show()    { DispatchQueue.main.async { NexivoWidget.shared.show() } }
    @objc func hide()    { DispatchQueue.main.async { NexivoWidget.shared.hide() } }
    @objc func destroy() { DispatchQueue.main.async { NexivoWidget.shared.destroy() } }

    override func addListener(_ eventName: String) {}
    override func removeListeners(_ count: Double) {}

    private static func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
}
```

---

### 5. Add files to Xcode

1. In Xcode, right-click your app folder in the Project Navigator → **Add Files to "YourApp"**
2. Select both `NexivoWidgetModule.m` and `NexivoWidgetModule.swift`, then click **Add**
3. When Xcode asks **"Would you like to configure an Objective-C bridging header?"** → click **Create Bridging Header**
   - This automatically creates `YourApp-Bridging-Header.h`

---

### 6. Update the Bridging Header

Open `YourApp-Bridging-Header.h` and add:

```objc
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
```

---

### 7. Create `NexivoWidget.js`

```js
import { NativeModules, NativeEventEmitter } from 'react-native';

const { NexivoWidget } = NativeModules;
const emitter = NexivoWidget ? new NativeEventEmitter(NexivoWidget) : null;
const noop = () => {};

export default {
    init(tenantId, widgetId, baseUrl = '') {
        if (!NexivoWidget) return;
        NexivoWidget.initWidget(tenantId, widgetId, baseUrl);
    },
    setToken(token) {
        if (!NexivoWidget) return;
        NexivoWidget.setToken(token);
    },
    show:        NexivoWidget ? () => NexivoWidget.show()    : noop,
    hide:        NexivoWidget ? () => NexivoWidget.hide()    : noop,
    destroy:     NexivoWidget ? () => NexivoWidget.destroy() : noop,
    addListener: emitter
        ? (cb) => emitter.addListener('NexivoEvent', cb)
        : () => ({ remove: noop }),
};
```

---

### 8. Usage

#### OTP auth (default)

```tsx
import React, { useEffect } from 'react';
import NexivoWidget from './NexivoWidget';

export default function App() {
    useEffect(() => {
        NexivoWidget.init(
            'your-tenant-id',
            'your-widget-id',
            'https://your-base-url.com'  // optional
        );
        NexivoWidget.show();

        const subscription = NexivoWidget.addListener((event) => {
            // event.action     → "CALL_INITIATED" | "CALL_RINGING" | "CALL_PICKED_UP" | "CALL_ENDED"
            // event.agentName  → display name of the agent
            // event.userId     → resolved Contact ID (available after auth)
            // event.token      → session token (available after auth)
            // event.timestamp  → Unix timestamp in milliseconds
            console.log('NexivoEvent:', event);
        });

        return () => {
            subscription.remove();
            NexivoWidget.destroy();
        };
    }, []);

    return (/* your app UI */);
}
```

#### SSO auth (`APP_CONNECT`)

> **Prerequisite:** the widget must be configured with `providerType: "APP_CONNECT"` on the Nexivo server side.

```tsx
import React, { useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import NexivoWidget from './NexivoWidget';

export default function App() {
    useEffect(() => {
        NexivoWidget.init(
            'your-tenant-id',
            'your-widget-id',
            'https://your-base-url.com'  // required
        );

        AsyncStorage.getItem('accessToken').then((token) => {
            if (token) NexivoWidget.setToken(token);
            NexivoWidget.show();
        });

        return () => NexivoWidget.destroy();
    }, []);

    return (/* your app UI */);
}
```

---

### API Reference

| Method | Description |
|--------|-------------|
| `NexivoWidget.init(tenantId, widgetId, baseUrl)` | Initialise the SDK. `baseUrl` is optional, defaults to `https://widget.nexivo.dev.cognitry.io`. |
| `NexivoWidget.setToken(token)` | Attach a JWT for `APP_CONNECT` SSO auth. |
| `NexivoWidget.show()` | Make the floating button visible. |
| `NexivoWidget.hide()` | Hide the floating button. |
| `NexivoWidget.destroy()` | Remove the widget and release resources. |

---

### Event Reference

| Field        | Type     | Description                                      |
|--------------|----------|--------------------------------------------------|
| `action`     | `string` | One of `CALL_INITIATED`, `CALL_RINGING`, `CALL_PICKED_UP`, `CALL_ENDED` |
| `agentName`  | `string` | Display name of the agent                        |
| `userId`     | `string` | Resolved Contact ID in the Nexivo system (set after auth) |
| `token`      | `string` | Session token (set after auth)                   |
| `timestamp`  | `number` | Unix timestamp in milliseconds                   |

---

## Credentials

Contact the Nexivo team to obtain your `tenantId` and `widgetId`.

</details>

---

<details>
<summary><strong>Flutter Integration</strong></summary>

<br>

### 1. Add the SDK package in Xcode

1. Open your Flutter project's `.xcworkspace` in Xcode (inside the `ios/` folder)
2. Go to **File → Add Package Dependencies**
3. Enter:
   ```
   https://github.com/aamir-core/nexivo-ios-sdk-releases
   ```
4. Select **Up to Next Major Version** from `1.1.2`
5. Click **Add Package**
6. Add **NexivoWidget** to your app target

---

### 2. Info.plist Permissions

Add these keys to your app's `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Nexivo needs microphone access for voice calls.</string>
<key>NSCameraUsageDescription</key>
<string>Nexivo needs camera access for video calls.</string>
```

---

### 3. Create `NexivoPlugin.swift`

Create this file inside `ios/Runner/`:

```swift
import Flutter
import UIKit
import NexivoWidgetCore

public class NexivoPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "nexivo_widget", binaryMessenger: registrar.messenger())
        let eventChannel  = FlutterEventChannel(name: "nexivo_widget/events", binaryMessenger: registrar.messenger())
        let instance = NexivoPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method {
        case "init":
            let tenantId = args?["tenantId"] as? String ?? ""
            let widgetId = args?["widgetId"] as? String ?? ""
            let baseUrl  = args?["baseUrl"]  as? String ?? ""
            DispatchQueue.main.async { [weak self] in
                guard let self, let window = Self.keyWindow() else { return }
                NexivoWidget.shared.initialize(
                    tenantId: tenantId,
                    widgetId: widgetId,
                    baseUrl:  baseUrl,
                    in:       window
                ) { [weak self] event in
                    DispatchQueue.main.async {
                        self?.eventSink?([
                            "action":    event.action,
                            "agentName": event.agentName,
                            "userId":    event.userId as Any,
                            "token":     event.token  as Any,
                            "timestamp": event.timestamp.timeIntervalSince1970 * 1000
                        ])
                    }
                }
            }
            result(nil)
        case "setToken":
            let token = args?["token"] as? String ?? ""
            DispatchQueue.main.async { NexivoWidget.shared.setToken(token) }
            result(nil)
        case "show":
            DispatchQueue.main.async { NexivoWidget.shared.show() }
            result(nil)
        case "hide":
            DispatchQueue.main.async { NexivoWidget.shared.hide() }
            result(nil)
        case "destroy":
            DispatchQueue.main.async { NexivoWidget.shared.destroy() }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    private static func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
}
```

---

### 4. Add file to Xcode

1. In Xcode, right-click the **Runner** folder in the Project Navigator → **Add Files to "Runner"**
2. Select `NexivoPlugin.swift` and click **Add**

---

### 5. Register in `AppDelegate.swift`

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if let registrar = self.registrar(forPlugin: "NexivoPlugin") {
            NexivoPlugin.register(with: registrar)
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

---

### 6. Dart Bridge

Create `lib/nexivo_widget.dart` in your Flutter project:

```dart
import 'dart:async';
import 'package:flutter/services.dart';

class NexivoEvent {
  final String action;
  final String agentName;
  final String? userId;
  final String? token;
  final double timestamp;

  const NexivoEvent({
    required this.action,
    required this.agentName,
    this.userId,
    this.token,
    required this.timestamp,
  });

  factory NexivoEvent.fromMap(Map<Object?, Object?> map) => NexivoEvent(
        action:    map['action']    as String? ?? '',
        agentName: map['agentName'] as String? ?? '',
        userId:    map['userId']    as String?,
        token:     map['token']     as String?,
        timestamp: (map['timestamp'] as num?)?.toDouble() ?? 0,
      );
}

class NexivoWidget {
  NexivoWidget._();

  static const _method = MethodChannel('nexivo_widget');
  static const _events = EventChannel('nexivo_widget/events');

  static Stream<NexivoEvent>? _stream;

  static Future<void> init({
    required String tenantId,
    required String widgetId,
    String baseUrl = '',
  }) =>
      _method.invokeMethod('init', {
        'tenantId': tenantId,
        'widgetId': widgetId,
        'baseUrl':  baseUrl,
      });

  static Future<void> setToken(String token) =>
      _method.invokeMethod('setToken', {'token': token});

  static Future<void> show()    => _method.invokeMethod('show');
  static Future<void> hide()    => _method.invokeMethod('hide');
  static Future<void> destroy() => _method.invokeMethod('destroy');

  static Stream<NexivoEvent> get onEvent {
    _stream ??= _events
        .receiveBroadcastStream()
        .map((e) => NexivoEvent.fromMap(e as Map<Object?, Object?>));
    return _stream!;
  }
}
```

---

### 7. Usage

#### OTP auth (default)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'nexivo_widget.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<NexivoEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _initNexivo();
  }

  Future<void> _initNexivo() async {
    await NexivoWidget.init(
      tenantId: 'your-tenant-id',
      widgetId: 'your-widget-id',
      // baseUrl: 'https://your-base-url.com',  // optional
    );
    await NexivoWidget.show();

    _subscription = NexivoWidget.onEvent.listen((event) {
      // event.action     → "CALL_INITIATED" | "CALL_RINGING" | "CALL_PICKED_UP" | "CALL_ENDED"
      // event.agentName  → display name of the agent
      // event.userId     → resolved Contact ID (available after auth)
      // event.token      → session token (available after auth)
      // event.timestamp  → Unix timestamp in milliseconds
      debugPrint('NexivoEvent: ${event.action} | ${event.agentName}');
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    NexivoWidget.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My App')),
        body: const Center(child: Text('Hello!')),
      ),
    );
  }
}
```

#### SSO auth (`APP_CONNECT`)

> **Prerequisite:** the widget must be configured with `providerType: "APP_CONNECT"` on the Nexivo server side.

```dart
Future<void> _initNexivo() async {
  await NexivoWidget.init(tenantId: 'your-tenant-id', widgetId: 'your-widget-id');

  final token = await _getStoredToken(); // your own auth token
  if (token != null) await NexivoWidget.setToken(token);
  await NexivoWidget.show();
}
```

---

### API Reference

| Method | Description |
|--------|-------------|
| `NexivoWidget.init(tenantId: widgetId: baseUrl:)` | Initialise the SDK. `baseUrl` is optional, defaults to `https://widget.nexivo.dev.cognitry.io`. |
| `NexivoWidget.setToken(token)` | Attach a JWT for `APP_CONNECT` SSO auth. |
| `NexivoWidget.show()` | Make the floating button visible. |
| `NexivoWidget.hide()` | Hide the floating button. |
| `NexivoWidget.destroy()` | Remove the widget and release resources. |

---

### Event Reference

| Field        | Type      | Description                                      |
|--------------|-----------|--------------------------------------------------|
| `action`     | `String`  | One of `CALL_INITIATED`, `CALL_RINGING`, `CALL_PICKED_UP`, `CALL_ENDED` |
| `agentName`  | `String`  | Display name of the agent                        |
| `userId`     | `String?` | Resolved Contact ID in the Nexivo system (set after auth) |
| `token`      | `String?` | Session token (set after auth)                   |
| `timestamp`  | `double`  | Unix timestamp in milliseconds                   |

---

## Credentials

Contact the Nexivo team to obtain your `tenantId` and `widgetId`.

</details>

---

## Notes

- The phone number input accepts **digits only** — do not include the country code (e.g. enter `9876543210`, not `+919876543210`). The country code is selected separately via the picker.
- The floating button can be **dragged** anywhere on screen and snaps to the nearest edge on release.
- Call and chat features are individually toggled by the widget configuration fetched from the server.
- Microphone and camera permissions are requested at runtime when the user initiates a call.
- When `providerType` is `APP_CONNECT`, call `setToken()` as soon as your user's token is available. The SDK buffers the token internally and applies it once the widget config has been fetched, so there is no need to wait for `initialize()` to complete before calling `setToken()`.
