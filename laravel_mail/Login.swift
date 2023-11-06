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
    // キーボードの非表示に使う
    @FocusState private var isActive:Bool
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
                        .padding(.horizontal, 20) // 左右に20ポイントの余白を追加
                        .padding(.top, 50) // 上に50ポイントの余白を追加
                    
                    Text("ID")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.blue)
                        .padding(.horizontal, 20) // 左右に20ポイントの余白を追加
                        .padding(.top, 50)
                    
                    // borderでもできる
                    // 注意点はborderの後に書いたpaddingは外、前に書いたのが中身になるから気をつける
                    TextField("メールアドレス", text: $model.mail)
                        .padding()
                        // 重ね表示形式で背景色指定
                        .background(
                            RoundedRectangle(cornerRadius: 10) // 角丸の背景を作成
                                .fill(Color.gray.opacity(0.2)) // 背景色を設定
                        )
                        // 背景で枠線指定
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2) // 青い枠線
                        )
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                        // 画面タップでキーボードを閉じる
                        .focused($isActive)
                    
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
                            RoundedRectangle(cornerRadius: 10) // 角丸の背景を作成
                                .fill(Color.gray.opacity(0.2)) // 背景色を設定
                        )
                        // 背景で枠線指定
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2) // 青い枠線
                        )
                        .padding(.horizontal, 20)
                        .autocapitalization(.none)
                    
                    // NavigationLink(destination: Mail(), isActive: $model.isLogin) {}
                    NavigationLink("", destination: Mail(), isActive: $model.isLogin)
                    Button(action: {
                        // ログイン
                        model.fetchData(apiFlg: "login")
                    }) {
                        // ボタンデザイン
                        HStack {
                            Spacer()
                            Text("ログイン")
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
                    
                    // 下記の{}の中にボタンを置いてやろうとすると$isRegisterに関係なく画面遷移が行われることがある。
                    // NavigationLink(destination: Register(), isActive: $isRegister){}
                    NavigationLink("", destination: Register(), isActive: $isRegister)
                    Button(action: {
                        isRegister.toggle()
                    }) {
                        Text("新規登録の方はこちら")
                            .font(.system(size: 16))
                            .foregroundColor(.gray) // テキストの色を変更する
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
        .onTapGesture {
            isActive = false
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().environmentObject(Model())
    }
}
