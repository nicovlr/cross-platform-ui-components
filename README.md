# CrossUI

Reusable UI components for Apple platforms. Swift, Objective-C, and C++ where performance matters.

## Why

Needed a shared set of components across a few personal projects. This is the extraction — nothing fancy, just things I keep rewriting.

## What's in here

### Swift / SwiftUI
- `AdaptiveStack` — switches between H/V stack based on size class
- `ShimmerView` — loading placeholder with shimmer animation
- `AsyncImageLoader` — image loading with cache and placeholder

### UIKit / Objective-C
- `NVGradientView` — gradient background view (used in older projects)
- `NVRoundedButton` — rounded button with built-in press animation

### C++
- `ColorUtils` — fast color space conversions (sRGB ↔ linear, HSL ↔ RGB)
- `LayoutEngine` — lightweight flex-like layout calculator

## Structure

```
Sources/
├── SwiftUI/       # Modern SwiftUI components
├── UIKit/         # UIKit wrappers and views
├── ObjC/          # Objective-C legacy components
└── Cpp/           # Performance-critical utilities
    ├── include/   # Headers
    └── src/       # Implementation
```

## Notes

The C++ layout engine is experimental — trying to get something that can run layout calculations off the main thread. Not production ready yet.
