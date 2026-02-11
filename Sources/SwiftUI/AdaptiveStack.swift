import SwiftUI

/// A stack that automatically switches between horizontal and vertical
/// layout based on the available size class.
public struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    let horizontalAlignment: VerticalAlignment
    let verticalAlignment: HorizontalAlignment
    let spacing: CGFloat?
    let content: () -> Content

    public init(
        horizontalAlignment: VerticalAlignment = .center,
        verticalAlignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        if sizeClass == .compact {
            VStack(alignment: verticalAlignment, spacing: spacing, content: content)
        } else {
            HStack(alignment: horizontalAlignment, spacing: spacing, content: content)
        }
    }
}
