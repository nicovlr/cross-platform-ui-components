import Foundation

/// Swift bridge for the C++ ColorUtils library.
/// Provides a native Swift API over the performance-critical C++ color math.
public struct ColorBridge {

    public struct RGB: Equatable {
        public var r: Float
        public var g: Float
        public var b: Float
        public init(r: Float, g: Float, b: Float) { self.r = r; self.g = g; self.b = b }
    }

    public struct HSL: Equatable {
        public var h: Float // 0-360
        public var s: Float // 0-1
        public var l: Float // 0-1
        public init(h: Float, s: Float, l: Float) { self.h = h; self.s = s; self.l = l }
    }

    // MARK: - sRGB / Linear

    /// Convert sRGB to linear RGB (gamma decode).
    public static func srgbToLinear(_ color: RGB) -> RGB {
        RGB(r: srgbComponentToLinear(color.r),
            g: srgbComponentToLinear(color.g),
            b: srgbComponentToLinear(color.b))
    }

    /// Convert linear RGB to sRGB (gamma encode).
    public static func linearToSrgb(_ color: RGB) -> RGB {
        RGB(r: linearComponentToSrgb(color.r),
            g: linearComponentToSrgb(color.g),
            b: linearComponentToSrgb(color.b))
    }

    // MARK: - HSL / RGB

    /// Convert RGB to HSL color space.
    public static func rgbToHsl(_ color: RGB) -> HSL {
        let maxC = max(color.r, color.g, color.b)
        let minC = min(color.r, color.g, color.b)
        let delta = maxC - minC
        let l = (maxC + minC) / 2.0

        guard delta > 0.00001 else { return HSL(h: 0, s: 0, l: l) }

        let s = l > 0.5 ? delta / (2.0 - maxC - minC) : delta / (maxC + minC)

        var h: Float
        if maxC == color.r {
            h = ((color.g - color.b) / delta).truncatingRemainder(dividingBy: 6.0)
        } else if maxC == color.g {
            h = (color.b - color.r) / delta + 2.0
        } else {
            h = (color.r - color.g) / delta + 4.0
        }
        h *= 60.0
        if h < 0 { h += 360.0 }
        return HSL(h: h, s: s, l: l)
    }

    /// Convert HSL to RGB color space.
    public static func hslToRgb(_ color: HSL) -> RGB {
        guard color.s > 0.00001 else { return RGB(r: color.l, g: color.l, b: color.l) }

        let q = color.l < 0.5 ? color.l * (1.0 + color.s) : color.l + color.s - color.l * color.s
        let p = 2.0 * color.l - q
        let hNorm = color.h / 360.0
        return RGB(r: hueToRgb(p, q, hNorm + 1.0 / 3.0),
                   g: hueToRgb(p, q, hNorm),
                   b: hueToRgb(p, q, hNorm - 1.0 / 3.0))
    }

    // MARK: - Interpolation

    /// Linearly interpolate between two colors in linear space for perceptually correct blending.
    public static func lerp(_ a: RGB, _ b: RGB, t: Float) -> RGB {
        let t = min(max(t, 0), 1)
        let linA = srgbToLinear(a), linB = srgbToLinear(b)
        return linearToSrgb(RGB(r: linA.r + (linB.r - linA.r) * t,
                                g: linA.g + (linB.g - linA.g) * t,
                                b: linA.b + (linB.b - linA.b) * t))
    }

    // MARK: - Private

    private static func srgbComponentToLinear(_ v: Float) -> Float {
        v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4)
    }
    private static func linearComponentToSrgb(_ v: Float) -> Float {
        v <= 0.0031308 ? v * 12.92 : 1.055 * pow(v, 1.0 / 2.4) - 0.055
    }
    private static func hueToRgb(_ p: Float, _ q: Float, _ t: Float) -> Float {
        var t = t
        if t < 0 { t += 1 }; if t > 1 { t -= 1 }
        if t < 1.0 / 6.0 { return p + (q - p) * 6.0 * t }
        if t < 1.0 / 2.0 { return q }
        if t < 2.0 / 3.0 { return p + (q - p) * (2.0 / 3.0 - t) * 6.0 }
        return p
    }
}
