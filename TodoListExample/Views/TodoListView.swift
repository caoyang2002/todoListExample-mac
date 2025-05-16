import SwiftUI
import SwiftData

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// TodoListView - Todo 列表视图
struct TodoListView: View {
    @State private var newTodoTitle: String = ""
    @State private var showingAddTodoAlert = false
    
    // 使用 AppStorage 来存储登录状态
    @AppStorage("currentUser") private var currentUser: String?
    
    // 获取 SwiftData 的 ModelContext
    @Environment(\.modelContext) private var modelContext
    
    // 使用 @Query 自动获取和监听 Todo 数据
    @Query private var todos: [Todo]
    
    // 初始化时设置查询条件
    init() {
        // 获取当前用户名
        guard let username = UserController.getCurrentUsername() else {
            // 默认空查询
            _todos = Query()
            return
        }
        
        // 创建查询，筛选当前用户的 Todo
        let predicate = #Predicate<Todo> { todo in
            todo.username == username
        }
        
        // 设置查询描述符
        let descriptor = FetchDescriptor<Todo>(predicate: predicate, sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        
        // 初始化 Query 属性包装器
        _todos = Query(descriptor)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Todo 列表
                List {
                    if todos.isEmpty {
                        Text("暂无待办事项")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(todos) { todo in
                            TodoRowView(todo: todo)
                        }
                        .onDelete(perform: deleteTodos)
                    }
                }
                
                // 添加新 Todo 的输入区域
                HStack {
                    
                    TextField("添加新任务", text: $newTodoTitle)
//                        .padding()
//                        .background(Color.gray.opacity(0.2)) // 使用系统灰色背景
                        .cornerRadius(4)
                        .font(.system(size: 16))  // 设置字体大小
                        .foregroundColor(.primary)  // 设置文字颜色
                        .accentColor(.blue)  // 设置光标和选中文本的颜色
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 2, y: 4)  // 添加阴影效果
                        .overlay(  // 添加边框
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue, lineWidth: 1)
                        )

                    Button(action: {
                        addTodo()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(newTodoTitle.isEmpty ? .gray : .blue)
                    }
                    .disabled(newTodoTitle.isEmpty)
                }
                .padding()
            }
            .navigationTitle("我的待办事项")
            .toolbar {
                // 跨平台的工具栏项
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    logoutButton
                }
                #elseif os(macOS)
                ToolbarItem {
                    logoutButton
                }
                #endif
            }
        }
    }
    
    // 提取退出登录按钮为属性，使代码更清晰
    private var logoutButton: some View {
        Button(action: {
            // 执行登出
            UserController.logout()
            // 清除当前用户
            currentUser = nil
            
            // 注意：使用 @AppStorage 方式无需手动重置应用，
            // 当主应用中检测到 currentUser 变为 nil 时会自动切换到登录视图
        }) {
            Text("退出登录")
        }
    }
    
    // 添加新 Todo
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        
        TodoController.addTodo(title: newTodoTitle, modelContext: modelContext)
        newTodoTitle = ""
    }
    
    // 删除 Todo
    private func deleteTodos(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            TodoController.deleteTodo(todo: todo, modelContext: modelContext)
        }
    }
}

// 预览提供者
#Preview {
    TodoListView()
        .modelContainer(for: [Todo.self, User.self], inMemory: true)
}
