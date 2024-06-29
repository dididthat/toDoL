import Foundation
import Combine

final class FileCache {
    @Published private(set) var toDoItems: [TodoItem] = []
    
    private let fileName: String
    private let fileManager: FileManager
    
    init(
        fileName: String = "Default",
        fileManager: FileManager = .default
    ) {
        self.fileName = fileName
        self.fileManager = fileManager
    }
    
    func addItem(_ item: TodoItem) {
        guard !toDoItems.contains(where: { $0.id == item.id }) else { return }
        toDoItems.append(item)
    }
    
    @discardableResult
    func deleteItem(with id: String) -> TodoItem? {
        guard let index = toDoItems.firstIndex(where: { $0.id == id }) else { return nil }
        return toDoItems.remove(at: index)
    }
    
    @discardableResult
    func replaceItem(_ item: TodoItem) -> Bool {
        guard let index = toDoItems.firstIndex(where: { $0.id == item.id }) else { return false }
        toDoItems[index] = item
        return true
    }
    
    @discardableResult
    func saveAllItems() -> Bool {
        guard let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let filePath = folder.appending(path: fileName)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: toDoItems.map { $0.json })
            try data.write(to: filePath)
            return true
        } catch {
            return false
        }
    }
    
    func loadItems() {
        guard 
            let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let data = try? Data(contentsOf: folder.appending(path: fileName)),
            let rawValues = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else {
            return
        }
        
        toDoItems = rawValues.compactMap { TodoItem.parse(json: $0) }
    }
}
