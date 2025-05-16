import SwiftUI

// 正确写法：struct 实现 Commands 协议
struct CustomCommands: Commands {
    var body: some Commands {
        // 文件菜单
        CommandMenu("文件") {
            Button("新建") {
                print("创建新文件")
            }
            .keyboardShortcut("n", modifiers: .command)
            
            // 其他菜单项...
        }
        
        CommandMenu("编辑") {
            Button("编辑1") {
                print("编辑1")
            }
            .keyboardShortcut("n", modifiers: .command)
            
            // 其他菜单项...
        }
    }
}
