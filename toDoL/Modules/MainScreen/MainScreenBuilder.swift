import SwiftUI

struct MainScreenBuilder {
    func build(
        fileCache: FileCache,
        detailsScreenBuilder: @escaping (String?) -> AnyView
    ) -> some View {
        let viewModel = MainScreenViewModel(fileCache: fileCache)
        let view = MainScreenView(viewModel: viewModel, detailsScreenBuilder: detailsScreenBuilder)
        return view
    }
}
