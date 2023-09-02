//
//  Mail.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct Message: Identifiable {
    let id: Int
    let title: String
    let content: String
    let time: String
}

struct Mail: View {
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
    
    @State private var isLogout: Bool = false
    @State var isMenuOpen: Bool = false
    @EnvironmentObject var model: Model
    
    var messages: [Message] {
        // model.nameの値を取得してmessages配列を初期化
        var message: [Message] = []
        for element in model.mailArray {
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
                    // 取り出した要素を使用して処理を行う
                    message.append(Message(id: id, title: name, content: content, time: createdAtFormat))
                }
            }
        }
        return message
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                List(messages) { message in
                    MessageView(message: message)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                NavigationLink(destination: Login(), isActive: $isLogout) {}
            }
            .navigationBarTitle("メール連絡網", displayMode: .inline)
            .navigationBarItems(leading: leadingBarItem)
            
        }
        .navigationBarHidden(true)
    }
    
    private var leadingBarItem: some View {
        Button(action: {
            isMenuOpen.toggle()
        }) {
            Image(systemName: "line.horizontal.3") // メニューアイコン
                .imageScale(.large)
                .foregroundColor(.white)
        }
        .sheet(isPresented: $isMenuOpen, content: {
            Button(action: {
                model.fetchData(apiFlg: "logout")
                isMenuOpen.toggle()
                if (model.isLogin) {
                    model.isLogin = false
                } else {
                    isLogout.toggle()
                }
            }) {
                Text("ログアウト")
                    .font(.system(size: 16))
                    .foregroundColor(.black) // テキストの色を変更する
                    .padding()
                    .border(Color.gray, width: 1)
            }
        })
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack {
                Text(self.message.title)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text(self.message.content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                Spacer()
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                Text(self.message.time)
                Spacer()
            }
            .padding(.horizontal)
        }.padding()
    }
}

struct Mail_Previews: PreviewProvider {
    static var previews: some View {
        Mail().environmentObject(Model())
    }
}
