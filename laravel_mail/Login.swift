//
//  Login.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedin: Bool = false
    @State private var isRegister: Bool = false
    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.gray
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 30)]
        //navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 40, weight: .bold)]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("ログイン").font(.system(size: 40)).padding(.bottom, 50)
                
                TextField("メールアドレス", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .autocapitalization(.none)
                
                SecureField("パスワード", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: Mail(), isActive: $isLoggedin) {
                    Button(action: {
                        // ログイン処理を実行すると仮定
                        // ここでは単にログイン状態を更新するだけとします
                        isLoggedin = true
                        saveToken()
                    }) {
                        HStack {
                            Spacer()
                            Text("ログイン")
                                .foregroundColor(.white)
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                }
                NavigationLink(destination: Register(), isActive: $isRegister) {
                    Button(action: {
                        isRegister.toggle()
                    }) {
                        Text("新規登録の場合はこちら")
                            .font(.system(size: 16))
                            .foregroundColor(.gray) // テキストの色を変更する
                            .padding(.top, 10)
                    }
                }
                .navigationBarTitle("メール連絡網", displayMode: .inline)
            }
        }
        .navigationBarHidden(true)
        
    }
    
    private func saveToken() {
        // APIで帰ってきたトークンを保存する
        UserDefaults.standard.set("test", forKey: "token")
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
