import SwiftUI
import SwiftData
import OSLog

@main
struct TodoApp: App {
    @AppStorage("currentUser") private var currentUser: String?

    var body: some Scene {
        WindowGroup {
            if currentUser != nil {
                TodoListView()
                    .onAppear {
                        Logger.app.info("已启动待办事项列表，当前用户: \(currentUser ?? "", privacy: .private)")
                    }
            } else {
                LoginView()
                    .onAppear {
                        Logger.app.info("已启动登录界面，未登录状态")
                    }
            }
        }
        .modelContainer(for: [Todo.self, User.self])
    }
}
