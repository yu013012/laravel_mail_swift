//
//  laravel_mailApp.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/08/31.
//

import SwiftUI

// MEMOアプリケーション起動時に@mainが読み込まれる
@main
struct laravel_mailApp: App {
    let model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
