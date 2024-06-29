import SwiftUI

struct EditingScreenView: View {
    @ObservedObject var viewModel: EditingScreenViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    textFieldView
                    extraBlockView
                    deleteButtonView
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: ColorScheme.backPrimary))
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: leadingBarButton)
                ToolbarItem(placement: .topBarTrailing, content: trailingBarButton)
            }
            .onReceive(viewModel.$shouldDismiss) { value in
                guard value else { return }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var textFieldView: some View {
        VStack {
            TextEditor(text: $viewModel.text)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 104, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .overlay(alignment: .topLeading) {
                    if viewModel.text.isEmpty {
                        Text("Что надо сделать?")
                            .foregroundStyle(Color(uiColor: ColorScheme.labelTertiary))
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                }
                .padding(8)
        }
        .background(Color(uiColor: ColorScheme.backSecondary))
        .cornerRadius(16)
    }
    
    private var extraBlockView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                importancePickerView
                Divider()
                deadlinePickerView
            }
            .padding(12)
        }
        .background(Color(uiColor: ColorScheme.backSecondary))
        .cornerRadius(16)
    }
    
    private var importancePickerView: some View {
        HStack {
            Text("Важность")
                .foregroundStyle(Color(uiColor: ColorScheme.labelPrimary))
            Spacer()

            Picker("", selection: $viewModel.selectedImportance) {
                ForEach(viewModel.availableImportances.indices, id: \.self) { index in
                    let value = viewModel.availableImportances[index]
                    switch value.label {
                    case .image(let image):
                        Image(uiImage: image.withRenderingMode(.alwaysOriginal))
                            .tag(index)
                        
                    case .text(let text):
                        Text(text)
                            .tag(index)
                    }
                }
            }
            .pickerStyle(.segmented)
            .fixedSize()
        }
    }
    
    private var deadlinePickerView: some View {
        VStack(spacing: .zero) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Сделать до")
                        .foregroundStyle(Color(uiColor: ColorScheme.labelPrimary))
                    if viewModel.isCalendarShowing {
                        Text(viewModel.formattedDeadline)
                            .foregroundStyle(Color(uiColor: ColorScheme.blue))
                    }
                }
                Spacer()
                Toggle("", isOn: $viewModel.isCalendarShowing)
            }
            
            if viewModel.isCalendarShowing {
                Divider()
                    .padding(.top, 12)
                DatePicker(
                    "Сделать до",
                    selection: $viewModel.deadlineDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, LocaleProvider.locale)
            }
        }
    }
    
    private var deleteButtonView: some View {
        Button(action: viewModel.deleteButtonTapped) {
            HStack {
                Text("Удалить")
                    .foregroundStyle(
                        Color(uiColor: viewModel.isDeleteButtonAvailable ? ColorScheme.red : ColorScheme.labelDisable)
                    )
            }
        }
        .disabled(!viewModel.isDeleteButtonAvailable)
        .frame(maxWidth: .infinity, idealHeight: 56)
        .background(Color(uiColor: ColorScheme.backSecondary))
        .cornerRadius(16)
    }
    
    private func leadingBarButton() -> some View {
        Button("Отменить", action: viewModel.cancelButtonTapped)
    }
    
    private func trailingBarButton() -> some View {
        Button(action: viewModel.saveButtonTapped) {
            Text("Сохранить")
                .foregroundStyle(
                    Color(uiColor: viewModel.isSaveButtonAvailable ? ColorScheme.blue : ColorScheme.labelDisable)
                )
                .disabled(!viewModel.isSaveButtonAvailable)
        }
    }
}
