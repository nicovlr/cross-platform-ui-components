#include "LayoutEngine.hpp"
#include <cassert>
#include <cmath>
#include <iostream>

using namespace crossui::layout;

static bool approxEqual(float a, float b, float eps = 0.5f) {
    return std::fabs(a - b) < eps;
}

void testBasicRow() {
    std::vector<LayoutNode> nodes = {
        {{100, 50}},
        {{100, 50}},
        {{100, 50}},
    };

    LayoutConfig config;
    config.direction = Direction::Row;
    config.containerSize = {400, 100};
    config.spacing = 10;

    auto frames = calculate(nodes, config);
    assert(frames.size() == 3);
    assert(approxEqual(frames[0].x, 0));
    assert(approxEqual(frames[1].x, 110));
    assert(approxEqual(frames[2].x, 220));
    std::cout << "  basic row: ok\n";
}

void testFlexGrow() {
    std::vector<LayoutNode> nodes = {
        {{50, 40}, 0},   // fixed
        {{0, 40}, 1},    // flexible
        {{50, 40}, 0},   // fixed
    };

    LayoutConfig config;
    config.direction = Direction::Row;
    config.containerSize = {300, 80};
    config.spacing = 0;

    auto frames = calculate(nodes, config);
    // middle item should fill remaining space: 300 - 50 - 50 = 200
    assert(approxEqual(frames[1].width, 200));
    std::cout << "  flex grow: ok\n";
}

void testCenterAlignment() {
    std::vector<LayoutNode> nodes = {
        {{80, 40}},
    };

    LayoutConfig config;
    config.direction = Direction::Row;
    config.mainAxis = Alignment::Center;
    config.containerSize = {300, 100};

    auto frames = calculate(nodes, config);
    assert(approxEqual(frames[0].x, 110)); // (300 - 80) / 2
    std::cout << "  center alignment: ok\n";
}

void testColumn() {
    std::vector<LayoutNode> nodes = {
        {{100, 30}},
        {{100, 30}},
    };

    LayoutConfig config;
    config.direction = Direction::Column;
    config.containerSize = {200, 300};
    config.spacing = 5;

    auto frames = calculate(nodes, config);
    assert(approxEqual(frames[0].y, 0));
    assert(approxEqual(frames[1].y, 35)); // 30 + 5
    std::cout << "  column: ok\n";
}

int main() {
    std::cout << "LayoutEngine tests\n";
    testBasicRow();
    testFlexGrow();
    testCenterAlignment();
    testColumn();
    std::cout << "all passed\n";
    return 0;
}
