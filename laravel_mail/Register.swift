//
//  Register.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Register: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password_confirm: String = ""
    @State private var isRegister: Bool = false
    @State private var isBack: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
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
                Text("新規登録").font(.system(size: 40)).padding(.bottom, 50)
                
                TextField("名前", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .autocapitalization(.none)
                
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
                
                SecureField("確認用パスワード", text: $password_confirm)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: Mail(), isActive: $isRegister) {
                    Button(action: {
                        // ログイン処理を実行すると仮定
                        // ここでは単にログイン状態を更新するだけとします
                        isRegister.toggle()
                        saveToken()
                    }) {
                        HStack {
                            Spacer()
                            Text("新規登録")
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
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("戻る")
                        .font(.system(size: 16))
                        .foregroundColor(.gray) // テキストの色を変更する
                        .padding(.top, 10)
                }
                
            }
            .navigationBarTitle("メール連絡網", displayMode: .inline)
        }
        .navigationBarHidden(true)
    }
    private func saveToken() {
        // APIで帰ってきたトークンを保存する
        UserDefaults.standard.set("test", forKey: "token")
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
