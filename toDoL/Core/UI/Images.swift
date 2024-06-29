import UIKit

enum Images {
    enum Fill {
        static let plusCircle = UIImage(named: "plus.circle.fill")!
    }
    
    enum Importance {
        static let lowPriority = UIImage(named: "low.priorty")!
        static let hightPriority = UIImage(named: "hight.priorty")!
    }
    
    enum ToggleStyle {
        static let off = UIImage(named: "toggle.off")!
        static let offHightPriority = UIImage(named: "toggle.off.hightPriority")!
        static let on = UIImage(named: "toggle.on")!
    }
    
    enum Navigation {
        static let action = UIImage(named: "navigation")!
    }
    
    enum SwipeActions {
        static let select = UIImage(systemName: "checkmark.circle.fill")!
        static let delete = UIImage(systemName: "trash")!
        static let info = UIImage(systemName: "info.circle.fill")!
    }
    
    static let calendar = UIImage(named: "calendar")!
}
