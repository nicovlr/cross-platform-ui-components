# CrossUI

A collection of reusable UI components for Apple platforms, spanning **Swift**, **Objective-C**, and **C++**. Built for performance-critical scenarios where working across the full stack — from SwiftUI down to system-level code — is necessary.

## Components

### SwiftUI

| Component | Description |
|-----------|-------------|
| `AdaptiveStack` | Automatically switches between `HStack`/`VStack` based on horizontal size class |
| `ShimmerView` | Skeleton loading placeholder with configurable shimmer animation + `.shimmerPlaceholder()` view modifier |
| `CachedAsyncImage` | Async image loader with `NSCache` (50MB limit, LRU eviction) |

### UIKit / Objective-C

| Component | Description |
|-----------|-------------|
| `NVGradientView` | `CAGradientLayer`-backed gradient view with dark mode support (`traitCollectionDidChange`) |
| `NVRoundedButton` | Rounded button with spring-animated press effect (scale on touch, spring back on release) |
| `GradientViewRepresentable` | `UIViewRepresentable` bridge — wraps Objective-C views for use in SwiftUI |

### C++ (Performance Layer)

| Component | Description |
|-----------|-------------|
| `ColorUtils` | Fast color space conversions: sRGB ↔ linear (gamma decode/encode), HSL ↔ RGB, pack/unpack RGBA8, linear interpolation |
| `LayoutEngine` | Lightweight flex-like layout calculator — row/column direction, flex grow, main/cross axis alignment, spacing, margins. Thread-safe, no UI dependency. |

## Architecture

```
Sources/
├── SwiftUI/       # Modern SwiftUI components
├── UIKit/         # UIViewRepresentable bridges
├── ObjC/          # Objective-C UIKit components
└── Cpp/
    ├── include/   # C++ headers
    └── src/       # C++ implementation
Tests/
├── ColorUtilsTests.cpp
└── LayoutEngineTests.cpp
```

The C++ layer is intentionally decoupled from UIKit/SwiftUI — it handles pure computation (color math, layout calculation) that can run on any thread without UI framework dependencies. The Objective-C components provide UIKit support, and SwiftUI components represent the modern API surface. The UIKit bridge layer enables gradual migration between the two.

## Building & Testing

```bash
# Run all C++ tests
make test

# Build individually
make build/color_tests
make build/layout_tests
```

Requires C++17. Compiled with `clang++`.

## Design Decisions

- **C++ for computation** — Color space math and layout calculations run off the main thread without Swift concurrency overhead
- **Self-contained components** — No shared protocols or base classes, each component is independent to reduce coupling
- **UIKit ↔ SwiftUI bridging** — `UIViewRepresentable` wrappers allow incremental adoption of SwiftUI alongside existing UIKit code
