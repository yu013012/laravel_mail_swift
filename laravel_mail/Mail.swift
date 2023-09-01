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
}

struct Mail: View {
    let messages: [Message] = [
        Message(id: 1, title: "Hello!", content: "Hello!Nice to meet you!"),
        Message(id: 2, title: "Hello!", content: "Hello!Nice to meet you!"),
        Message(id: 3, title: "Hello!", content: "Hello!Nice to meet you!"),
        Message(id: 4, title: "Hello!", content: "Hello!Nice to meet you!"),
        Message(id: 5, title: "Hello!", content: "Hello!Nice to meet you!"),
    ]
    @State var isMenuOpen: Bool = false
    @ObservedObject var model = Model()
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
                List(messages) { message in
                    MessageView(message: message)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("メール連絡網", displayMode: .inline)
            .navigationBarItems(leading: leadingBarItem)
            .sheet(isPresented: $isMenuOpen, content: {
                Button(action: {
                    // MEMO ログアウト処理
                }) {
                    Text("ログアウト")
                        .font(.system(size: 16))
                        .foregroundColor(.black) // テキストの色を変更する
                        .padding()
                        .border(Color.gray, width: 1)
                }
            })
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
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack {
                Text(self.message.title)
                    .padding(.horizontal)
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
            }
            .padding(.horizontal)
        }
    }
}

struct Mail_Previews: PreviewProvider {
    static var previews: some View {
        Mail()
    }
}
