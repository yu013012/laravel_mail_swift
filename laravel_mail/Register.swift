//
//  Register.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Register: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
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
                Text("新規登録").font(.system(size: 40)).padding(.bottom, 50)
                
                TextField("名前", text: $model.name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .autocapitalization(.none)
                
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
                
                SecureField("確認用パスワード", text: $model.password_confirm)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: Mail(), isActive: $model.isRegister) {
                    Button(action: {
                        model.fetchData(apiFlg: "register")
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
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register().environmentObject(Model())
    }
}
