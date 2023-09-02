//
//  Login.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Login: View {
    // MEMO APIに絡んでいるやつだけ共通化する
    @State private var isRegister: Bool = false
    @EnvironmentObject var model: Model
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
                
                TextField("メールアドレス", text: $model.mail)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .autocapitalization(.none)
                
                SecureField("パスワード", text: $model.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: Mail(), isActive: $model.isLogin) {
                    Button(action: {
                        // ログイン
                        model.fetchData(apiFlg: "login")
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
                .alert(isPresented: $model.error) {
                    Alert(
                        title: Text("エラー"),
                        message: Text("エラーが発生しました。"),
                        dismissButton: .default(
                            Text("閉じる"),
                            action: {
                                model.error = false
                            }
                        )
                    )
                }
                .navigationBarTitle("メール連絡網", displayMode: .inline)
            }
        }
        .navigationBarHidden(true)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().environmentObject(Model())
    }
}
