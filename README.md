# Nexivo Widget SDK — iOS

A native iOS SDK that provides a floating call/chat widget with agent card, phone/OTP verification, and live voice/video calling via LiveKit.

---

## Requirements

- iOS 15+
- Xcode 15+
- Swift 5.9+

---

## Installation

### Swift Package Manager

**Step 1 — Add the Nexivo SDK**

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the package URL:
   ```
   https://github.com/aamir-core/nexivo-ios-sdk-releases
   ```
3. Select **Up to Next Major Version** from `1.0.5`
4. Click **Add Package**
5. Add **NexivoWidget** to your app target

**Step 2 — Add LiveKit (required peer dependency)**

The SDK uses LiveKit for voice/video calls but does not bundle it. You must add it separately:

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the package URL:
   ```
   https://github.com/livekit/client-sdk-swift
   ```
3. Select **Up to Next Major Version** from `2.5.0`
4. Click **Add Package**
5. Add **LiveKit** to your app target

> Skipping this step will cause `Undefined symbol: LiveKit.*` linker errors at build time.

---

## Info.plist Permissions

Add these keys to your app's `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Nexivo needs microphone access for voice calls.</string>
<key>NSCameraUsageDescription</key>
<string>Nexivo needs camera access for video calls.</string>
```

---

## Native iOS Usage

```swift
import NexivoWidgetSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let window = window {
            NexivoWidget.shared.initialize(
                tenantId: "your-tenant-id",
                widgetId: "your-widget-id",
                baseUrl:  "https://your-api-base-url",
                in: window
            ) { event in
                print("action=\(event.action) agent=\(event.agentName)")
            }
            NexivoWidget.shared.show()
        }
        return true
    }
}
```

---

<details>
<summary><strong>React Native Integration</strong></summary>

### 1. Add the SDK package in Xcode

1. Open your React Native project's `.xcworkspace` in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter:
   ```
   https://github.com/aamir-core/nexivo-ios-sdk-releases
   ```
4. Add **NexivoWidget** to your app target

---

### 2. Objective-C bridge — `NexivoWidgetModule.m`

Create in `ios/YourApp/`:

```objc
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_REMAP_MODULE(NexivoWidget, NexivoWidgetModule, RCTEventEmitter)

RCT_EXTERN_METHOD(initWidget:(NSString *)tenantId widgetId:(NSString *)widgetId baseUrl:(NSString *)baseUrl)
RCT_EXTERN_METHOD(show)
RCT_EXTERN_METHOD(hide)
RCT_EXTERN_METHOD(destroy)

@end
```

---

### 3. Swift module — `NexivoWidgetModule.swift`

Create in `ios/YourApp/`:

```swift
import UIKit
import React
import NexivoWidgetSDK

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
                    "timestamp": event.timestamp.timeIntervalSince1970 * 1000
                ])
            }
        }
    }

    @objc func show()    { DispatchQueue.main.async { NexivoWidget.shared.show() } }
    @objc func hide()    { DispatchQueue.main.async { NexivoWidget.shared.hide() } }
    @objc func destroy() { DispatchQueue.main.async { NexivoWidget.shared.destroy() } }

    private static func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
}
```

---

### 4. JS bridge — `src/NexivoWidget.js`

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
    show:        NexivoWidget ? () => NexivoWidget.show()    : noop,
    hide:        NexivoWidget ? () => NexivoWidget.hide()    : noop,
    destroy:     NexivoWidget ? () => NexivoWidget.destroy() : noop,
    addListener: emitter
        ? (cb) => emitter.addListener('NexivoEvent', cb)
        : () => ({ remove: noop }),
};
```

---

### 5. Use in your app

```tsx
import React, { useEffect } from 'react';
import NexivoWidget from './src/NexivoWidget';

export default function App() {
    useEffect(() => {
        NexivoWidget.init(
            'your-tenant-id',
            'your-widget-id',
            'https://your-api-base-url'
        );
        NexivoWidget.show();

        const sub = NexivoWidget.addListener((event) => {
            console.log('NexivoEvent:', event);
        });

        return () => {
            sub.remove();
            NexivoWidget.destroy();
        };
    }, []);

    return (/* your app UI */);
}
```

</details>

---

## Event Reference

| `action`         | When it fires                           |
|------------------|-----------------------------------------|
| `CALL_INITIATED` | User tapped Start Call                  |
| `CALL_RINGING`   | Connected to LiveKit, waiting for agent |
| `CALL_PICKED_UP` | Agent joined the room                   |
| `CALL_ENDED`     | Call ended (either side hung up)        |

---

## Notes

- The phone number input accepts **digits only** — do not include the country code (e.g. enter `9876543210`, not `+919876543210`). The country code is selected separately via the picker.
- The floating button can be **dragged** anywhere on screen and snaps to the nearest edge on release.
- Call and chat features are individually toggled by the widget configuration fetched from the server.
