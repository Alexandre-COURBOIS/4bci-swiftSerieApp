import SwiftUI

@main
struct SerieApp: App {
    init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.blue]
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
