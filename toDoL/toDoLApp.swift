import SwiftUI

@main
struct toDoLApp: App {
    private let dependenciesContaner = AppDependenciesContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreenBuilder().build(
                    fileCache: dependenciesContaner.fileCache,
                    detailsScreenBuilder: { id in
                        AnyView(EditingScreenBuilder().build(fileCache: dependenciesContaner.fileCache, id: id))
                    }
                )
            }
            .onAppear {
                dependenciesContaner.fileCache.loadItems()
            }
        }
    }
}
