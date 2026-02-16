import SwiftUI

/// Toast notification style configuration.
public struct ToastStyle {
    public enum Position { case top, bottom }

    public var position: Position
    public var duration: TimeInterval
    public var backgroundColor: Color
    public var foregroundColor: Color

    public init(position: Position = .bottom, duration: TimeInterval = 2.5,
                backgroundColor: Color = Color(.systemGray6), foregroundColor: Color = .primary) {
        self.position = position; self.duration = duration
        self.backgroundColor = backgroundColor; self.foregroundColor = foregroundColor
    }
}

/// A toast notification view that slides in from the top or bottom.
public struct ToastView: View {
    let message: String
    let icon: String?
    let style: ToastStyle

    public init(message: String, icon: String? = nil, style: ToastStyle = .init()) {
        self.message = message; self.icon = icon; self.style = style
    }

    public var body: some View {
        HStack(spacing: 10) {
            if let icon { Image(systemName: icon).font(.body.bold()) }
            Text(message).font(.subheadline.weight(.medium))
        }
        .foregroundStyle(style.foregroundColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(style.backgroundColor, in: Capsule())
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
    }
}

/// View modifier that presents a toast notification.
struct ToastModifier: ViewModifier {
    @Binding var isPresenting: Bool
    let message: String
    let icon: String?
    let style: ToastStyle
    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: style.position == .top ? .top : .bottom) {
                if isPresenting {
                    ToastView(message: message, icon: icon, style: style)
                        .transition(.move(edge: style.position == .top ? .top : .bottom).combined(with: .opacity))
                        .padding(style.position == .top ? .top : .bottom, 16)
                        .onAppear {
                            dismissTask?.cancel()
                            dismissTask = Task {
                                try? await Task.sleep(for: .seconds(style.duration))
                                guard !Task.isCancelled else { return }
                                withAnimation(.easeOut(duration: 0.3)) { isPresenting = false }
                            }
                        }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresenting)
    }
}

extension View {
    /// Present a toast notification that auto-dismisses after a duration.
    public func toast(isPresenting: Binding<Bool>, message: String, icon: String? = nil,
                      style: ToastStyle = .init()) -> some View {
        modifier(ToastModifier(isPresenting: isPresenting, message: message, icon: icon, style: style))
    }
}
