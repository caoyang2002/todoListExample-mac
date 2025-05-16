// 在单独的 Logger.swift 文件中
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.yourcompany.todoapp"
    
    // 针对不同模块的日志器
    static let app = Logger(subsystem: subsystem, category: "app")
    static let views = Logger(subsystem: subsystem, category: "views")
    static let models = Logger(subsystem: subsystem, category: "models")
    static let auth = Logger(subsystem: subsystem, category: "authentication")
}
