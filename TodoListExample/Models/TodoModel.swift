import Foundation
import SwiftData

// Todo 模型 - 使用 SwiftData 的 @Model 宏定义数据模型
@Model
class Todo {
    var title: String       // 任务标题
    var isCompleted: Bool   // 完成状态
    var createdAt: Date     // 创建时间
    var username: String    // 关联的用户名
    
    // 初始化方法
    init(title: String, isCompleted: Bool = false, username: String) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
        self.username = username
    }
}

// User 模型 - 简单的用户模型
@Model
class User {
    var username: String    // 用户名
    var password: String    // 密码 (注意：实际应用中应该加密存储)
    
    // 初始化方法
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
