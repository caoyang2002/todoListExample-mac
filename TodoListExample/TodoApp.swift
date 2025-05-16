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
        .commands {
            // 替换默认的文件菜单
            CommandGroup(replacing: .newItem) {
                  Button("新建项目") {
                      print("创建新的自定义项目")
                  }
                  
                  Button("其他新建选项") {
                      print("其他新建选项")
                  }
              }
            // 替换默认的编辑菜单
            CommandGroup(replacing: .pasteboard) {
                Button("自定义复制") {
                    print("执行自定义复制")
                }
                   
               Button("自定义粘贴") {
                   print("执行自定义粘贴")
               }
           }
               
           // 添加到现有菜单中，而不是替换
           CommandGroup(after: .pasteboard) {
               Divider()
               Button("特殊格式粘贴") {
                   print("特殊格式粘贴")
               }
           }
            // 自定义
            CustomCommands()
        }
    }
}
