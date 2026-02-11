#pragma once

#include <cstdint>
#include <algorithm>
#include <cmath>

namespace crossui {

struct RGBf {
    float r, g, b; // 0.0 - 1.0
};

struct HSL {
    float h; // 0 - 360
    float s; // 0 - 1
    float l; // 0 - 1
};

struct RGBA8 {
    uint8_t r, g, b, a;
};

namespace color {

/// sRGB to linear RGB (gamma decode)
inline float srgbToLinear(float v) {
    if (v <= 0.04045f)
        return v / 12.92f;
    return std::pow((v + 0.055f) / 1.055f, 2.4f);
}

/// Linear RGB to sRGB (gamma encode)
inline float linearToSrgb(float v) {
    if (v <= 0.0031308f)
        return v * 12.92f;
    return 1.055f * std::pow(v, 1.0f / 2.4f) - 0.055f;
}

RGBf srgbToLinear(RGBf c);
RGBf linearToSrgb(RGBf c);

HSL rgbToHsl(RGBf c);
RGBf hslToRgb(HSL c);

/// Pack float RGB to 8-bit RGBA
RGBA8 pack(RGBf c, uint8_t alpha = 255);

/// Unpack 8-bit RGBA to float RGB
RGBf unpack(RGBA8 c);

/// Lerp between two colors in linear space
RGBf lerp(RGBf a, RGBf b, float t);

} // namespace color
} // namespace crossui
