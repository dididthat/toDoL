import Foundation
import Combine

final class MainScreenViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    @Published var isEditing = false
    
    var completedTasks: Int {
        items.filter { $0.isCompleted }.count
    }
    
    private(set) var selectedItemId: String?
    
    private let fileCache: FileCache
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = LocaleProvider.locale
        formatter.setLocalizedDateFormatFromTemplate("d MMM")
        return formatter
    }()
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        bind()
    }
    
    func itemDidTap(id: String) {
        selectedItemId = id
        isEditing = true
    }
    
    func createItemButtonDidTap() {
        isEditing = true
    }
    
    func changeItemCompletedState(for isCompleted: Bool, item: TodoItem) {
        fileCache.replaceItem(item.with(isCompleted: isCompleted))
        fileCache.saveAllItems()
    }
    
    func deleteItem(id: String) {
        fileCache.deleteItem(with: id)
        fileCache.saveAllItems()
    }
    
    func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    private func bind() {
        fileCache.$toDoItems.sink { [weak self] in
            self?.items = $0
        }.store(in: &cancellables)
        
        $isEditing.sink { [weak self] isEditing in
            if !isEditing {
                self?.selectedItemId = nil
            }
        }.store(in: &cancellables)
    }
}
