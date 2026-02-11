#pragma once

#include <vector>
#include <cstdint>

namespace crossui {
namespace layout {

enum class Direction {
    Row,
    Column
};

enum class Alignment {
    Start,
    Center,
    End,
    SpaceBetween
};

struct Size {
    float width = 0;
    float height = 0;
};

struct Rect {
    float x = 0;
    float y = 0;
    float width = 0;
    float height = 0;
};

struct LayoutNode {
    Size preferredSize;
    float flexGrow = 0;     // 0 = fixed, >0 = flexible
    float minWidth = 0;
    float minHeight = 0;
    float marginStart = 0;
    float marginEnd = 0;
};

struct LayoutConfig {
    Direction direction = Direction::Row;
    Alignment mainAxis = Alignment::Start;
    Alignment crossAxis = Alignment::Start;
    float spacing = 0;
    Size containerSize;
};

/// Calculate layout frames for a set of nodes.
/// Runs on any thread — no UI dependency.
std::vector<Rect> calculate(
    const std::vector<LayoutNode>& nodes,
    const LayoutConfig& config
);

} // namespace layout
} // namespace crossui
