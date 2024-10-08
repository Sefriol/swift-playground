import SwiftUI
import os

struct LoggerKey: EnvironmentKey {
    static let defaultValue: Logger = Logger(subsystem: "com.example.MyApp", category: "general")
}

extension EnvironmentValues {
    var logger: Logger {
        get { self[LoggerKey.self] }
        set { self[LoggerKey.self] = newValue }
    }
}

@main
struct MyApp: App {
    let logger = Logger(subsystem: "com.example.MyApp", category: "general")
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                ContentView()
                    .environment(\.logger, logger)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
