#include "ColorUtils.hpp"

namespace crossui {
namespace color {

RGBf srgbToLinear(RGBf c) {
    return {
        srgbToLinear(c.r),
        srgbToLinear(c.g),
        srgbToLinear(c.b)
    };
}

RGBf linearToSrgb(RGBf c) {
    return {
        linearToSrgb(c.r),
        linearToSrgb(c.g),
        linearToSrgb(c.b)
    };
}

HSL rgbToHsl(RGBf c) {
    float maxC = std::max({c.r, c.g, c.b});
    float minC = std::min({c.r, c.g, c.b});
    float delta = maxC - minC;

    HSL result;
    result.l = (maxC + minC) / 2.0f;

    if (delta < 0.00001f) {
        result.h = 0.0f;
        result.s = 0.0f;
        return result;
    }

    result.s = (result.l > 0.5f)
        ? delta / (2.0f - maxC - minC)
        : delta / (maxC + minC);

    if (maxC == c.r) {
        result.h = std::fmod((c.g - c.b) / delta, 6.0f);
    } else if (maxC == c.g) {
        result.h = (c.b - c.r) / delta + 2.0f;
    } else {
        result.h = (c.r - c.g) / delta + 4.0f;
    }

    result.h *= 60.0f;
    if (result.h < 0.0f) result.h += 360.0f;

    return result;
}

static float hueToRgb(float p, float q, float t) {
    if (t < 0.0f) t += 1.0f;
    if (t > 1.0f) t -= 1.0f;
    if (t < 1.0f / 6.0f) return p + (q - p) * 6.0f * t;
    if (t < 1.0f / 2.0f) return q;
    if (t < 2.0f / 3.0f) return p + (q - p) * (2.0f / 3.0f - t) * 6.0f;
    return p;
}

RGBf hslToRgb(HSL c) {
    if (c.s < 0.00001f) {
        return {c.l, c.l, c.l};
    }

    float q = (c.l < 0.5f)
        ? c.l * (1.0f + c.s)
        : c.l + c.s - c.l * c.s;
    float p = 2.0f * c.l - q;
    float hNorm = c.h / 360.0f;

    return {
        hueToRgb(p, q, hNorm + 1.0f / 3.0f),
        hueToRgb(p, q, hNorm),
        hueToRgb(p, q, hNorm - 1.0f / 3.0f)
    };
}

RGBA8 pack(RGBf c, uint8_t alpha) {
    auto clamp = [](float v) -> uint8_t {
        return static_cast<uint8_t>(std::clamp(v, 0.0f, 1.0f) * 255.0f + 0.5f);
    };
    return {clamp(c.r), clamp(c.g), clamp(c.b), alpha};
}

RGBf unpack(RGBA8 c) {
    return {
        static_cast<float>(c.r) / 255.0f,
        static_cast<float>(c.g) / 255.0f,
        static_cast<float>(c.b) / 255.0f
    };
}

RGBf lerp(RGBf a, RGBf b, float t) {
    t = std::clamp(t, 0.0f, 1.0f);
    return {
        a.r + (b.r - a.r) * t,
        a.g + (b.g - a.g) * t,
        a.b + (b.b - a.b) * t
    };
}

} // namespace color
} // namespace crossui
