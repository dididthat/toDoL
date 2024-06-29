import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    
    enum Priority {
        case `default`
        case hight
    }
    
    private let priority: Priority
    
    init(priority: Priority = .default) {
        self.priority = priority
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .zero) {
            image(with: configuration)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    configuration.isOn.toggle()
                }

            configuration.label
        }
    }
    
    private func image(with configuration: Configuration) -> Image {
        let image: UIImage
        if configuration.isOn {
            image = Images.ToggleStyle.on
        } else {
            switch priority {
            case .default:
                image = Images.ToggleStyle.off
            case .hight:
                image = Images.ToggleStyle.offHightPriority
            }
        }
        return Image(uiImage: image)
    }
}
