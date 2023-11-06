//
//  Mail.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Message: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let content: String
    let time: String
}

struct Mail: View {
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
    
    @State private var isLogout: Bool = false
    @State var isMenuOpen: Bool = false
    @EnvironmentObject var model: Model
    @State private var scrollProxy: ScrollViewProxy?
    @State private var last_id: Int = 0
    
    var messages: [Message] {
        // model.nameの値を取得してmessages配列を初期化
        var message: [Message] = []
        for element in model.mailArray {
            // elementがキーstring、中身anyか
            if let jsonDict = element as? [String: Any] {
                // JSONオブジェクトの解析
                if let content = jsonDict["content"] as? String,
                   var createdAtFormat = jsonDict["created_at_format"] as? String,
                   let id = jsonDict["id"] as? Int,
                   let name = jsonDict["name"] as? String
                {
                    let autoSend = jsonDict["auto_send"] as? String
                    if autoSend != "", autoSend != nil {
                        createdAtFormat = autoSend!
                    }
                    // スクロール指定に使う
                    self.last_id = id
                    // 取り出した要素を使用して処理を行う
                    message.append(Message(id: id, title: name, content: content, time: createdAtFormat))
                }
            }
        }
        return message
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        NavigationLink("", destination: Login(), isActive: $isLogout)
                        // scrollviewの中でlistが使えない、listはwidgetで自動でスクロールをつけてくれるからかな
                        // scrollviewがないとスクロールしてくれない
                        ForEach(messages, id: \.id) { message in
                            MessageView(message: message)
                        }
                    }
                    .onAppear {
                        // 自動スクロールに使う
                        scrollProxy = proxy
                    }
                }
            }
            .onChange(of: messages) { _ in
                // メッセージが更新されたら一番下までスクロール
                withAnimation {
                    scrollProxy?.scrollTo(self.last_id)
                }
            }
            .navigationBarTitle("メール連絡網", displayMode: .inline)
            .navigationBarItems(leading: leadingBarItem)
            .overlay(
                // 画面サイズ取得に使う
                GeometryReader { geometry in
                    HStack {
                        SideMenuView(isVisible: $isMenuOpen, isMenuOpen: $isMenuOpen, isLogout: $isLogout)
                            .frame(width: geometry.size.width / 2)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .offset(x: (isMenuOpen ? 0 : geometry.size.width / 2) * -1)
                }
            )
        }
        .navigationBarHidden(true)
    }
    
    private var leadingBarItem: some View {
        Button(action: {
            // これを使えば中身で指定しているstateが変更したときに起こるアクション(デザイン面で)にアニメーションをつけることができる。
            withAnimation {
                isMenuOpen.toggle()
            }
        }) {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .foregroundColor(.white)
                // テスト時に指定するためのid
                .accessibilityIdentifier("menuIconImage")
        }
        // 下から出てくるモーダル的なもの
//        .sheet(isPresented: $isMenuOpen, content: {
//            Button(action: {
//                model.fetchData(apiFlg: "logout")
//                isMenuOpen.toggle()
//                if (model.isLogin) {
//                    model.isLogin = false
//                } else {
//                    isLogout.toggle()
//                }
//            }) {
//                Text("ログアウト")
//                    .font(.system(size: 16))
//                    .foregroundColor(.black) // テキストの色を変更する
//                    .padding()
//                    .border(Color.gray, width: 1)
//            }
//        })
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack {
                Text(self.message.title)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            Text(self.message.content)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    // 枠線、角10、色青、太さ8
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 6)
                )
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                Text(self.message.time)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .padding()
        // 自動スクロールのためのid
        .id(self.message.id)
    }
}

struct Mail_Previews: PreviewProvider {
    static var previews: some View {
        Mail().environmentObject(Model())
    }
}

// ハンバーガーメニューの中身
struct SideMenuView: View {
    @Binding var isVisible: Bool
    @EnvironmentObject var model: Model
    @Binding var isMenuOpen: Bool
    @Binding var isLogout: Bool
    
    var body: some View {
        List {
            Text("ログアウト")
                .onTapGesture {
                    model.fetchData(apiFlg: "logout")
                    isMenuOpen.toggle()
                    if (model.isLogin) {
                        model.isLogin = false
                    } else {
                        isLogout.toggle()
                    }
                }
            Text("サンプルボタン")
            // 他のメニューアイテムを追加
        }
        .listStyle(SidebarListStyle())
    }
}
