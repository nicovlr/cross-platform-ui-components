import XCTest

final class ColorBridgeTests: XCTestCase {
    func testSrgbRoundtrip() {
        let original = ColorBridge.RGB(r: 0.5, g: 0.2, b: 0.8)
        let linear = ColorBridge.srgbToLinear(original)
        let back = ColorBridge.linearToSrgb(linear)
        XCTAssertEqual(original.r, back.r, accuracy: 0.01)
        XCTAssertEqual(original.g, back.g, accuracy: 0.01)
        XCTAssertEqual(original.b, back.b, accuracy: 0.01)
    }

    func testHslRoundtrip() {
        let original = ColorBridge.RGB(r: 0.8, g: 0.3, b: 0.5)
        let hsl = ColorBridge.rgbToHsl(original)
        let back = ColorBridge.hslToRgb(hsl)
        XCTAssertEqual(original.r, back.r, accuracy: 0.01)
        XCTAssertEqual(original.g, back.g, accuracy: 0.01)
        XCTAssertEqual(original.b, back.b, accuracy: 0.01)
    }

    func testLerpMidpoint() {
        let a = ColorBridge.RGB(r: 0, g: 0, b: 0)
        let b = ColorBridge.RGB(r: 1, g: 1, b: 1)
        let mid = ColorBridge.lerp(a, b, t: 0.5)
        XCTAssertGreaterThan(mid.r, 0.3)
        XCTAssertLessThan(mid.r, 0.8)
    }

    func testLerpClamping() {
        let a = ColorBridge.RGB(r: 0.2, g: 0.2, b: 0.2)
        let b = ColorBridge.RGB(r: 0.8, g: 0.8, b: 0.8)
        let under = ColorBridge.lerp(a, b, t: -1.0)
        let over = ColorBridge.lerp(a, b, t: 2.0)
        XCTAssertEqual(under.r, a.r, accuracy: 0.01)
        XCTAssertEqual(over.r, b.r, accuracy: 0.01)
    }

    func testGrayscaleHsl() {
        let gray = ColorBridge.RGB(r: 0.5, g: 0.5, b: 0.5)
        let hsl = ColorBridge.rgbToHsl(gray)
        XCTAssertEqual(hsl.s, 0, accuracy: 0.001)
        XCTAssertEqual(hsl.l, 0.5, accuracy: 0.001)
    }

    func testPureRedHsl() {
        let red = ColorBridge.RGB(r: 1, g: 0, b: 0)
        let hsl = ColorBridge.rgbToHsl(red)
        XCTAssertEqual(hsl.h, 0, accuracy: 1.0)
        XCTAssertEqual(hsl.s, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsl.l, 0.5, accuracy: 0.01)
    }
}
