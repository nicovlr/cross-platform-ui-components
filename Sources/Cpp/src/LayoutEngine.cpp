#include "LayoutEngine.hpp"
#include <numeric>
#include <algorithm>

namespace crossui {
namespace layout {

std::vector<Rect> calculate(
    const std::vector<LayoutNode>& nodes,
    const LayoutConfig& config
) {
    if (nodes.empty()) return {};

    std::vector<Rect> frames(nodes.size());
    bool isRow = (config.direction == Direction::Row);
    float containerMain = isRow ? config.containerSize.width : config.containerSize.height;
    float containerCross = isRow ? config.containerSize.height : config.containerSize.width;

    // pass 1: sum fixed sizes and flex factors
    float totalFixed = 0;
    float totalFlex = 0;
    float totalSpacing = config.spacing * static_cast<float>(nodes.size() - 1);

    for (const auto& node : nodes) {
        float mainSize = isRow ? node.preferredSize.width : node.preferredSize.height;
        totalFixed += mainSize + node.marginStart + node.marginEnd;
        totalFlex += node.flexGrow;
    }

    float availableFlex = std::max(0.0f, containerMain - totalFixed - totalSpacing);

    // pass 2: compute sizes
    std::vector<float> mainSizes(nodes.size());
    for (size_t i = 0; i < nodes.size(); ++i) {
        float base = isRow ? nodes[i].preferredSize.width : nodes[i].preferredSize.height;
        float extra = (totalFlex > 0 && nodes[i].flexGrow > 0)
            ? availableFlex * (nodes[i].flexGrow / totalFlex)
            : 0;
        float minMain = isRow ? nodes[i].minWidth : nodes[i].minHeight;
        mainSizes[i] = std::max(base + extra, minMain);
    }

    // pass 3: position along main axis
    float cursor = 0;

    // handle SpaceBetween
    float spaceBetween = config.spacing;
    if (config.mainAxis == Alignment::SpaceBetween && nodes.size() > 1) {
        float totalUsed = 0;
        for (size_t i = 0; i < nodes.size(); ++i) {
            totalUsed += mainSizes[i] + nodes[i].marginStart + nodes[i].marginEnd;
        }
        spaceBetween = (containerMain - totalUsed) / static_cast<float>(nodes.size() - 1);
    }

    // starting offset
    if (config.mainAxis == Alignment::Center) {
        float totalUsed = totalSpacing;
        for (size_t i = 0; i < nodes.size(); ++i) {
            totalUsed += mainSizes[i] + nodes[i].marginStart + nodes[i].marginEnd;
        }
        cursor = (containerMain - totalUsed) / 2.0f;
    } else if (config.mainAxis == Alignment::End) {
        float totalUsed = totalSpacing;
        for (size_t i = 0; i < nodes.size(); ++i) {
            totalUsed += mainSizes[i] + nodes[i].marginStart + nodes[i].marginEnd;
        }
        cursor = containerMain - totalUsed;
    }

    for (size_t i = 0; i < nodes.size(); ++i) {
        cursor += nodes[i].marginStart;

        float crossSize = isRow ? nodes[i].preferredSize.height : nodes[i].preferredSize.width;
        if (crossSize <= 0) crossSize = containerCross;

        // cross axis alignment
        float crossPos = 0;
        if (config.crossAxis == Alignment::Center) {
            crossPos = (containerCross - crossSize) / 2.0f;
        } else if (config.crossAxis == Alignment::End) {
            crossPos = containerCross - crossSize;
        }

        if (isRow) {
            frames[i] = {cursor, crossPos, mainSizes[i], crossSize};
        } else {
            frames[i] = {crossPos, cursor, crossSize, mainSizes[i]};
        }

        cursor += mainSizes[i] + nodes[i].marginEnd;
        if (i < nodes.size() - 1) {
            cursor += spaceBetween;
        }
    }

    return frames;
}

} // namespace layout
} // namespace crossui
