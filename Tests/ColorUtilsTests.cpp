#include "ColorUtils.hpp"
#include <cassert>
#include <cmath>
#include <iostream>

using namespace crossui;

static bool approxEqual(float a, float b, float eps = 0.01f) {
    return std::fabs(a - b) < eps;
}

void testSrgbRoundtrip() {
    RGBf original = {0.5f, 0.2f, 0.8f};
    RGBf linear = color::srgbToLinear(original);
    RGBf back = color::linearToSrgb(linear);

    assert(approxEqual(original.r, back.r));
    assert(approxEqual(original.g, back.g));
    assert(approxEqual(original.b, back.b));
    std::cout << "  sRGB roundtrip: ok\n";
}

void testHslRoundtrip() {
    RGBf original = {0.8f, 0.3f, 0.5f};
    HSL hsl = color::rgbToHsl(original);
    RGBf back = color::hslToRgb(hsl);

    assert(approxEqual(original.r, back.r));
    assert(approxEqual(original.g, back.g));
    assert(approxEqual(original.b, back.b));
    std::cout << "  HSL roundtrip: ok\n";
}

void testPackUnpack() {
    RGBf original = {1.0f, 0.5f, 0.0f};
    RGBA8 packed = color::pack(original);
    RGBf unpacked = color::unpack(packed);

    assert(packed.r == 255);
    assert(packed.a == 255);
    assert(approxEqual(original.r, unpacked.r, 0.02f));
    std::cout << "  pack/unpack: ok\n";
}

void testLerp() {
    RGBf a = {0.0f, 0.0f, 0.0f};
    RGBf b = {1.0f, 1.0f, 1.0f};
    RGBf mid = color::lerp(a, b, 0.5f);

    assert(approxEqual(mid.r, 0.5f));
    assert(approxEqual(mid.g, 0.5f));
    assert(approxEqual(mid.b, 0.5f));
    std::cout << "  lerp: ok\n";
}

int main() {
    std::cout << "ColorUtils tests\n";
    testSrgbRoundtrip();
    testHslRoundtrip();
    testPackUnpack();
    testLerp();
    std::cout << "all passed\n";
    return 0;
}
