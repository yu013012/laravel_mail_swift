//
//  ContentView.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    @State private var isLogin: Bool = false
    @State private var isMail: Bool = false
    @EnvironmentObject var model: Model
    
    var body: some View {
        // MEMO NavigationView NavigationLinkはセット
        NavigationView {
            VStack {
                NavigationLink(destination: Mail(), isActive: $isMail) {
                    EmptyView()
                }
                NavigationLink(destination: Login(), isActive: $isLogin) {
                    EmptyView()
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
            }
            
        }
        
        // MEMO これをやると起動時に呼び出される
        .onAppear {
            if UserDefaults.standard.string(forKey: "token") != "", UserDefaults.standard.string(forKey: "token") != nil {
                model.token = UserDefaults.standard.string(forKey: "token") ?? ""
                model.fetchData(apiFlg: "mail")
                isMail.toggle()
            } else {
                isLogin = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Model())
    }
}
