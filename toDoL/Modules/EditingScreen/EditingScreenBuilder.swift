import SwiftUI

struct EditingScreenBuilder {
    func build(fileCache: FileCache, id: String?) -> some View {
        let viewModel = EditingScreenViewModel(fileCache: fileCache, id: id)
        let view = EditingScreenView(viewModel: viewModel)
        return view
    }
}
