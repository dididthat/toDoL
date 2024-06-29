import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    let detailsScreenBuilder: (_ id: String?) -> AnyView
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.items, id: \.id) { item in
                    Button(action: {
                        viewModel.itemDidTap(id: item.id)
                    }, label: {
                        itemCellView(for: item)
                    })
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            viewModel.changeItemCompletedState(for: !item.isCompleted, item: item)
                        }, label: {
                            Image(uiImage: Images.SwipeActions.select)
                                .resizable()
                                .frame(width: 27, height: 27)
                        })
                        .tint(Color(uiColor: ColorScheme.green))
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            viewModel.deleteItem(id: item.id)
                        }, label: {
                            Image(uiImage: Images.SwipeActions.delete)
                                .resizable()
                                .frame(width: 27, height: 27)
                        })
                        .tint(Color(uiColor: ColorScheme.red))
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            viewModel.itemDidTap(id: item.id)
                        }, label: {
                            Image(uiImage: Images.SwipeActions.info)
                                .resizable()
                                .frame(width: 27, height: 27)
                        })
                        .tint(Color(uiColor: ColorScheme.grayLight))
                    }
                }
            } header: {
                Text("Выполнено - \(viewModel.completedTasks)")
            }
        }
        .navigationTitle("Мои дела")
        .background(Color(uiColor: ColorScheme.backPrimary))
        .overlay(alignment: .bottom) {
            createItemButtonView
        }
        .popover(isPresented: $viewModel.isEditing) {
            detailsScreenBuilder(viewModel.selectedItemId)
        }
    }
    
    private func itemCellView(for element: TodoItem) -> some View {
        let itemCompletedBinding = Binding {
            element.isCompleted
        } set: {
            viewModel.changeItemCompletedState(for: $0, item: element)
        }
        
        return Toggle(isOn: itemCompletedBinding) {
            HStack(spacing: 4) {
                leadingIconView(for: element)
                textView(for: element)
                Spacer()
                Image(uiImage: Images.Navigation.action)
                    .resizable()
                    .frame(width: 7, height: 12)
            }
            .padding(.leading, 8)
        }
        .toggleStyle(CheckboxToggleStyle(priority: element.importance == .important ? .hight : .default))
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func leadingIconView(for item: TodoItem) -> some View {
        if !item.isCompleted {
            switch item.importance {
            case .unimportant:
                Image(uiImage: Images.Importance.lowPriority)
                    .resizable()
                    .frame(width: 16, height: 20)
            case .usual:
                EmptyView()
            case .important:
                Image(uiImage: Images.Importance.hightPriority)
                    .resizable()
                    .frame(width: 16, height: 20)
            }
        }
    }
    
    private func textView(for item: TodoItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.text)
                .foregroundStyle(
                    Color(uiColor: item.isCompleted ? ColorScheme.labelTertiary : ColorScheme.labelPrimary)
                )
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .strikethrough(item.isCompleted, color: Color(uiColor: ColorScheme.labelTertiary))
            if let deadline = item.deadline {
                HStack(spacing: 2) {
                    Image(uiImage: Images.calendar)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color(uiColor: ColorScheme.labelTertiary))
                        .frame(width: 16, height: 16)
                    Text(viewModel.formattedDate(deadline))
                        .foregroundStyle(Color(uiColor: ColorScheme.labelTertiary))
                }
            }
        }
    }
    
    private var createItemButtonView: some View {
        Button(action: viewModel.createItemButtonDidTap) {
            Image(uiImage: Images.Fill.plusCircle)
                .resizable()
                .frame(width: 44, height: 44)
        }
        .padding(.bottom, 20)
    }
}
