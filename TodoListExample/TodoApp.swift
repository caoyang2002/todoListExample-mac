import SwiftUI
import SwiftData

@main
struct TodoApp: App {
    // 使用 AppStorage 来跟踪登录状态
    @AppStorage("currentUser") private var currentUser: String?
    
    var body: some Scene {
        WindowGroup {
            // 基于 AppStorage 值动态切换视图
            if currentUser != nil {
                TodoListView()
            } else {
                LoginView()
            }
        }
        // 添加 SwiftData 模型容器配置
        .modelContainer(for: [Todo.self, User.self])
    }
}
