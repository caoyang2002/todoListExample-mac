import Foundation
import SwiftData
import OSLog

// UserController - 处理用户相关的业务逻辑
class UserController {
    // 验证用户登录
    static func login(username: String, password: String, modelContext: ModelContext) -> Bool {
        // 创建查询
        let predicate = #Predicate<User> { user in
            user.username == username && user.password == password
        }
        let descriptor = FetchDescriptor<User>(predicate: predicate)
        
        do {
            // 执行查询
            let users = try modelContext.fetch(descriptor)
            
            if users.isEmpty {
                // 用户不存在，创建新用户
                Logger.views.debug("用户不存在，创建新用户")
                let newUser = User(username: username, password: password)
                modelContext.insert(newUser)
                // 保存当前用户到 UserDefaults
                UserDefaults.standard.set(username, forKey: "currentUser")
                return true
            } else {
                // 用户存在，验证成功
                UserDefaults.standard.set(username, forKey: "currentUser")
                return true
            }
        } catch {
            print("登录失败: \(error)")
            return false
        }
    }
    
    // 用户登出
    static func logout() {
        Logger.app.debug("用户登出")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    // 获取当前登录的用户名
    static func getCurrentUsername() -> String? {
        return UserDefaults.standard.string(forKey: "currentUser")
    }
}

// TodoController - 处理 Todo 相关的业务逻辑
class TodoController {
    // 添加新的 Todo 项
    static func addTodo(title: String, modelContext: ModelContext) {
        guard let username = UserController.getCurrentUsername() else { return }
        
        let newTodo = Todo(title: title, username: username)
        modelContext.insert(newTodo)
    }
    
    // 删除 Todo 项
    static func deleteTodo(todo: Todo, modelContext: ModelContext) {
        modelContext.delete(todo)
    }
    
    // 切换 Todo 完成状态
    static func toggleTodoStatus(todo: Todo) {
        todo.isCompleted.toggle()
    }
    
    // 获取用户的 Todo 列表
    static func fetchUserTodos(modelContext: ModelContext) -> [Todo] {
        guard let username = UserController.getCurrentUsername() else { return [] }
        
        // 创建查询，筛选当前用户的 Todo
        let predicate = #Predicate<Todo> { todo in
            todo.username == username
        }
        let descriptor = FetchDescriptor<Todo>(predicate: predicate)
        
        do {
            // 执行查询
            return try modelContext.fetch(descriptor)
        } catch {
            print("获取 Todo 列表失败: \(error)")
            return []
        }
    }
}
