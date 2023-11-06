//
//  Register.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Register: View {
    // 環境変数から戻るために定義
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model: Model
    
    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.blue
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 30)]
        //navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 40, weight: .bold)]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text("ユーザーログイン")
                        .font(.largeTitle)
                        // 枠線の前のpaddingは枠線の中身
                        .padding()
                        // 横いっぱい
                        .frame(maxWidth: .infinity)
                        .background(
                            // 枠線、角10、色青、太さ8
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 6)
                        )
                        .foregroundColor(Color.blue)
                        // 外のpaddingは枠線の外
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                    
                    Text("名前")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                    
                    TextField("名前", text: $model.name)
                        .padding()
                        // 重ね表示形式で背景色指定
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        )
                        // 背景で枠線指定
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                    
                    Text("ID")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                    
                    TextField("メールアドレス", text: $model.mail)
                        .padding()
                        // 重ね表示形式で背景色指定
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        )
                        // 背景で枠線指定
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                    
                    Text("パスワード")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                    
                    SecureField("パスワード", text: $model.password)
                        .padding()
                        // 重ね表示形式で背景色指定
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        )
                        // 背景で枠線指定
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                    
                    Text("確認パスワード")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                    
                    SecureField("確認用パスワード", text: $model.password_confirm)
                        .padding()
                        // 重ね表示形式で背景色指定
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        )
                        // 背景で枠線指定
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                    
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
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 50)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("戻る")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                    
                }
                .navigationBarTitle("メール連絡網", displayMode: .inline)
                Image("logo") // 画像名を指定
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.all)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register().environmentObject(Model())
    }
}
