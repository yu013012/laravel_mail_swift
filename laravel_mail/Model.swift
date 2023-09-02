//
//  Model.swift
//  laravel_mail
//
//  Created by 丹羽悠 on 2023/09/01.
//

import Foundation

class Model: ObservableObject {
    @Published var token: String = ""
    @Published var fcm_token: String = ""
    @Published var name: String = ""
    @Published var mail: String = ""
    @Published var password: String = ""
    @Published var password_confirm: String = ""
    @Published var error: Bool = false
    @Published var isLogin: Bool = false
    @Published var isRegister: Bool = false
    @Published var mailArray: [ [String: Any] ] = []

    func fetchData(apiFlg: String) {
        // MEMO guard let nilじゃないことを確認して取り出すために使う
        // letはkotolinで言うval
        let url = switchUrl(flg: apiFlg)
        if url == nil || url == "" {
            self.error = true
            self.saveToken(token: "")
            return
        }
        // APIエンドポイントのURL
        let apiUrl = URL(string: url)
        if apiUrl == nil {
            self.error = true
            self.saveToken(token: "")
            return
        }
        
        // リクエストを作成
        // MEMO !をつけていてnilだった場合エラーになるから対策をする
        var request = URLRequest(url: apiUrl!)

        // ヘッダーを追加
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // HTTPメソッドを設定（GET、POST、PUT、DELETEなど）
        request.httpMethod = "GET"

        // セッションを作成
        let session = URLSession.shared

        // リクエストを送信
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("エラー: \(error)")
                self.error = true
                self.saveToken(token: "")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("エラー: \(httpResponse.statusCode)")
                    self.error = true
                    self.saveToken(token: "")
                    return
                }
            }

            if let data = data {
                // レスポンスデータを処理
                print("レスポンスデータ: \(data)")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.switchJson(flg: apiFlg,json: json)
                    } else {
                        self.error = true
                        self.saveToken(token: "")
                    }
                } catch {
                    self.error = true
                    self.saveToken(token: "")
                    print("JSONデコードエラー: \(error)")
                }
            }
        }

        // リクエストを実行
        task.resume()
    }
    
    func switchJson(flg: String, json: [String : Any]) {
        switch flg {
            case "login":
                if let token = json["data"] as? String {
                    self.token = token as String
                    self.saveToken(token: token)
                    self.isLogin = true
                    self.fetchData(apiFlg: "mail")
                } else {
                    self.error.toggle()
                }
            case "register":
                if let token = json["data"] as? String {
                    self.token = token as String
                    self.saveToken(token: token)
                    self.isRegister = true
                    self.fetchData(apiFlg: "mail")
                } else {
                    self.error.toggle()
                }
            case "mail":
                if let dataArray = json["data"] as? NSArray {
                    self.mailArray = dataArray as! [[String : Any]]
                } else {
                    self.error.toggle()
                }
            case "logout":
                if let token = json["data"] as? String {
                    self.saveToken(token: "")
                } else {
                    self.error.toggle()
                }
            case "fcm":
                if let token = json["data"] as? String {
                } else {
                    self.error.toggle()
                }
            default:
                self.error.toggle()
        }
    }
    
    func switchUrl(flg: String) -> String {
        switch flg {
            case "login":
                return Constants.apiUrl + "login?email=\(self.mail)&password=\(self.password)"
            case "register":
                return Constants.apiUrl + "register?name=\(self.name)&email=\(self.mail)&password=\(self.password)&password_confirmation=\(self.password_confirm)"
            case "mail":
                return Constants.apiUrl + "mail_data"
            case "logout":
                return Constants.apiUrl + "logout"
            case "fcm_token":
                return Constants.apiUrl + "fcm_token?fcm_token=\(self.fcm_token)"
            default:
                return ""
                self.error.toggle()
        }
    }
    
    func saveToken(token: String) {
        // APIで帰ってきたトークンを保存する
        UserDefaults.standard.set(token, forKey: "token")
    }
}
