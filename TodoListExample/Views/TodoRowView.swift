import SwiftUI

// TodoRowView - 单个 Todo 项的行视图
struct TodoRowView: View {
    @Environment(\.modelContext) private var modelContext
    // 接收 Todo 模型
    let todo: Todo
    
    var body: some View {
        HStack {
            // 完成状态按钮
            Button(action: {
                TodoController.toggleTodoStatus(todo: todo)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            // Todo 标题
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .primary)
            
            Spacer()
//            Divider()
            
            // 删除
            Button(action: {
                TodoController.deleteTodo(todo: todo, modelContext: modelContext)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            
            // 显示创建时间
            Text(formatDate(todo.createdAt))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    // 日期格式化辅助函数
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// 这个预览需要手动配置，初学者可以先忽略
 #Preview {
     TodoRowView(todo: Todo(title: "示例任务", username: "test"))
         .modelContainer(for: [Todo.self], inMemory: true)
 }
