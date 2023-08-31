//
//  ContentView.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    @State private var loginFlg: Bool = false
    @State private var mailFlg: Bool = false
    
    var body: some View {
        // MEMO NavigationView NavigationLinkはセット
        NavigationView {
            VStack {
                NavigationLink(destination: Mail(), isActive: $mailFlg) {
                    EmptyView()
                }
                NavigationLink(destination: Login(), isActive: $loginFlg) {
                    EmptyView()
                }
            }
        }
        // MEMO これをやると起動時に呼び出される
        .onAppear {
            if UserDefaults.standard.string(forKey: "token") != nil {
                mailFlg = true
            } else {
                loginFlg = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
