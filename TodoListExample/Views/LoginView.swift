import SwiftUI
import SwiftData

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // 使用 AppStorage 存储登录状态
    @AppStorage("currentUser") private var currentUser: String?
    
    // 获取 SwiftData 的 ModelContext
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Todo 案例")
                    .font(.largeTitle)
                    .padding(.top, 50)
                
                // 用户名输入框
                TextField("用户名", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2)) // 跨平台兼容的颜色
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // 密码输入框
                SecureField("密码", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2)) // 跨平台兼容的颜色
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // 登录按钮
                Button(action: {
                    // 验证输入非空
                    if username.isEmpty || password.isEmpty {
                        alertMessage = "用户名和密码不能为空"
                        showingAlert = true
                        return
                    }
                    
                    // 调用登录方法
                    if UserController.login(username: username, password: password, modelContext: modelContext) {
                        // 设置 AppStorage 变量，应用将自动切换视图
                        currentUser = username
                    } else {
                        alertMessage = "登录失败"
                        showingAlert = true
                    }
                }) {
                    Text("登录")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // 简单说明
                Text("初次登录将自动创建账户")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            }
        }
    }
}

// 预览提供者
#Preview {
    LoginView()
        .modelContainer(for: [User.self], inMemory: true)
}
