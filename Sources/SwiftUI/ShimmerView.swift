import SwiftUI

/// A shimmer/skeleton loading placeholder.
/// Use as an overlay or standalone placeholder while content loads.
public struct ShimmerView: View {
    @State private var phase: CGFloat = -1.0

    let cornerRadius: CGFloat
    let baseColor: Color
    let highlightColor: Color

    public init(
        cornerRadius: CGFloat = 8,
        baseColor: Color = Color(.systemGray5),
        highlightColor: Color = Color(.systemGray4)
    ) {
        self.cornerRadius = cornerRadius
        self.baseColor = baseColor
        self.highlightColor = highlightColor
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(baseColor)
            .overlay {
                GeometryReader { geo in
                    let width = geo.size.width
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, highlightColor.opacity(0.4), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width * 0.6)
                        .offset(x: phase * width)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .onAppear {
                withAnimation(
                    .linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.5
                }
            }
    }
}

// convenience modifier
extension View {
    public func shimmerPlaceholder(isLoading: Bool, cornerRadius: CGFloat = 8) -> some View {
        self
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay {
                if isLoading {
                    ShimmerView(cornerRadius: cornerRadius)
                }
            }
    }
}
