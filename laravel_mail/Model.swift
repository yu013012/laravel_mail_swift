//
//  Model.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/09/01.
//

import Foundation

class Model: ObservableObject {
    @Published var count: Int = 0
    
    func increment() {
        count += 1
    }
    
    func decrement() {
        count -= 1
    }
}
