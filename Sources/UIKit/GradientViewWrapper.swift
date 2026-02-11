import SwiftUI
import UIKit

/// SwiftUI wrapper for the ObjC gradient view.
/// Keeping this around for projects that still use it.
struct GradientViewRepresentable: UIViewRepresentable {
    let colors: [UIColor]
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    func makeUIView(context: Context) -> UIView {
        // NVGradientView would be used here when linked properly
        // for now just using a plain gradient layer
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.colors = colors.map(\.cgColor)
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let gradient = uiView.layer.sublayers?.first as? CAGradientLayer else { return }
        gradient.frame = uiView.bounds
        gradient.colors = colors.map(\.cgColor)
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
    }
}
