import SwiftUI

@main
struct Main: App {
    // Initialize the app and set up dependencies
    init() {
        // Initialize NotificationManager when the app starts
        // The underscore ignores the return value since we just need to trigger initialization
        _ = NotificationManager.shared
    }
    
    // Main app scene configuration
    var body: some Scene {
        // The primary window group containing the app's content
        WindowGroup {
            // The root view of the application
            ContentView()
        }
    }
}