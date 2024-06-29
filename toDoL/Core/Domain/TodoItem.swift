import Foundation

struct TodoItem: Equatable {
    enum Importance: String {
        case unimportant
        case usual
        case important
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let creationDate : Date
    let modificationDate : Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isCompleted: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.creationDate  = creationDate
        self.modificationDate  = modificationDate
    }
    
    func with(
        text: String? = nil,
        importance: Importance? = nil,
        isCompleted: Bool? = nil,
        creationDate: Date? = nil,
        modificationDate: Date? = nil
    ) -> Self {
        return TodoItem(
            id: id,
            text: text ?? self.text,
            importance: importance ?? self.importance,
            deadline: deadline,
            isCompleted: isCompleted ?? self.isCompleted,
            creationDate: creationDate ?? self.creationDate,
            modificationDate: modificationDate ?? self.modificationDate
        )
    }
}

// MARK: - DTO

extension TodoItem {
    private enum CodingKeys {
        static let id = "id"
        static let text = "text"
        static let importance = "importance"
        static let deadline = "deadline"
        static let isCompleted = "isCompleted"
        static let creationDate = "creationDate"
        static let modificationDate = "modificationDate"
    }
    
    var json: Any {
        var result: [String: Any] = [
            CodingKeys.id: id,
            CodingKeys.text: text,
            CodingKeys.isCompleted: isCompleted,
            CodingKeys.creationDate: creationDate.timeIntervalSince1970,
        ]
        
        if importance != .usual {
            result[CodingKeys.importance] = importance.rawValue
        }
        
        if let deadline {
            result[CodingKeys.deadline] = deadline.timeIntervalSince1970
        }
        
        if let modificationDate {
            result[CodingKeys.modificationDate] = modificationDate.timeIntervalSince1970
        }
        
        return result
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard
            let data = json as? [String: Any],
            let id = data[CodingKeys.id] as? String,
            let text = data[CodingKeys.text] as? String,
            let isCompleted  = data[CodingKeys.isCompleted] as? Bool,
            let creationDateRawValue = data[CodingKeys.creationDate] as? TimeInterval
        else {
            return nil
        }
        
        let importanceRawValue = data[CodingKeys.importance] as? String
        let deadlineRawValue = data[CodingKeys.deadline] as? TimeInterval
        let modificationDateRawValue = data[CodingKeys.modificationDate] as? TimeInterval
        
        return TodoItem(
            id: id,
            text: text,
            importance: importanceRawValue.flatMap { Importance(rawValue: $0) } ?? .usual,
            deadline: deadlineRawValue.map { Date(timeIntervalSince1970: $0) },
            isCompleted: isCompleted,
            creationDate: Date(timeIntervalSince1970: creationDateRawValue),
            modificationDate: modificationDateRawValue.map { Date(timeIntervalSince1970: $0) }
        )
    }
    
    var csv: String {
        let deadlineString = deadline?.timeIntervalSince1970.description ?? ""
        let modificationDateString = modificationDate?.timeIntervalSince1970.description ?? ""
        return "\(id),\(text),\(importance.rawValue),\(deadlineString),\(isCompleted),\(creationDate.timeIntervalSince1970),\(modificationDateString)"
    }
    
    static func parse(csv: String) -> TodoItem? {
        let components = csv.components(separatedBy: ",")
        
        guard
            components.count == 7,
            let isCompleted = Bool(components[4]),
            let creationDateInterval = TimeInterval(components[5])
        else {
            return nil
        }
        
        let id = components[0]
        let text = components[1]
        let importance = Importance(rawValue: components[2]) ?? .usual
        let deadline = components[3].isEmpty ? nil : Date(timeIntervalSince1970: TimeInterval(components[3]) ?? 0)
        let creationDate = Date(timeIntervalSince1970: creationDateInterval)
        let modificationDate = components[6].isEmpty ? nil : Date(timeIntervalSince1970: TimeInterval(components[6]) ?? 0)
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
    
}
