import SwiftUI
import Combine

final class EditingScreenViewModel: ObservableObject {
    
    struct Importance: Equatable {
        enum Label: Equatable {
            case image(UIImage)
            case text(String)
        }
        
        let label: Label
        let value: TodoItem.Importance
    }
    
    @Published var text: String
    @Published var deadlineDate: Date
    @Published var isCalendarShowing: Bool
    @Published var isDeleteButtonAvailable: Bool
    @Published var shouldDismiss = false
    @Published var selectedImportance = 2
    @Published var isSaveButtonAvailable = false
    
    let availableImportances = [
        Importance(label: .image(Images.Importance.lowPriority), value: .unimportant),
        Importance(label: .text("нет"), value: .usual),
        Importance(label: .image(Images.Importance.hightPriority), value: .important),
    ]
    
    var formattedDeadline: String {
        dateFormatter.string(from: deadlineDate)
    }
    
    private let fileCache: FileCache
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = LocaleProvider.locale
        formatter.setLocalizedDateFormatFromTemplate("d MMM yyyy")
        return formatter
    }()
    
    private var item: TodoItem?
    private var cancellables: Set<AnyCancellable> = []
    
    init(fileCache: FileCache, id: String?) {
        self.fileCache = fileCache
        item = fileCache.toDoItems.first(where: { $0.id == id })
        isCalendarShowing = item?.deadline != nil
        deadlineDate = item?.deadline ?? Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        isDeleteButtonAvailable = item != nil
        text = item?.text ?? ""
        
        selectedImportance = availableImportances.firstIndex(where: { $0.value == item?.importance }) ?? 1
        
        bind()
    }
    
    func cancelButtonTapped() {
        shouldDismiss = true
    }
    
    func saveButtonTapped() {
        guard isSaveButtonAvailable else { return }
        
        let item = TodoItem(
            id: item?.id ?? UUID().uuidString,
            text: text,
            importance: availableImportances[selectedImportance].value,
            deadline: isCalendarShowing ? deadlineDate : nil,
            modificationDate: Date()
        ).with(
            isCompleted: item?.isCompleted,
            creationDate: item?.creationDate
        )
        
        if self.item != nil {
            fileCache.replaceItem(item)
        } else {
            fileCache.addItem(item)
        }
        fileCache.saveAllItems()
        
        shouldDismiss = true
    }
    
    func deleteButtonTapped() {
        guard isDeleteButtonAvailable else { return }
        
        if let item {
            fileCache.deleteItem(with: item.id)
            fileCache.saveAllItems()
        }
        
        shouldDismiss = true
    }
    
    private func bind() {
        $text.sink { [weak self] in
            self?.isSaveButtonAvailable = !$0.isEmpty
            self?.isDeleteButtonAvailable = !$0.isEmpty
        }.store(in: &cancellables)
    }
}
