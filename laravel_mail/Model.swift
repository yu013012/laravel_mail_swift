//
//  Model.swift
//  larav
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
    // keyがString、値がAnyということ
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
        // MEMO !をつけていてnilだった場合エラーになるからその前に対策をする
        var request = URLRequest(url: apiUrl!)

        // ヘッダーを追加
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")

        // HTTPメソッドを設定（GET、POST、PUT、DELETEなど）
        request.httpMethod = "GET"

        // セッションを作成
        let session = URLSession.shared

        // リクエストを送信
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("エラー: \(error)")
                DispatchQueue.main.async {
                    self.error = true
                    self.saveToken(token: "")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    // MEMO 画面の変更だったり変数の変更は下記で行わなければならない
                    // バックグラウンドか、メインスレッドかの違い
                    DispatchQueue.main.async {
                        print("エラー: \(httpResponse.statusCode)")
                        self.error = true
                        self.saveToken(token: "")
                        return
                    }
                }
            }

            if let data = data {
                // レスポンスデータを処理
                print("レスポンスデータ: \(data)")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.switchJson(flg: apiFlg, json: json)
                    } else {
                        DispatchQueue.main.async {
                            self.error = true
                            self.saveToken(token: "")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = true
                        self.saveToken(token: "")
                        print("JSONデコードエラー: \(error)")
                    }
                }
            }
        }
        // リクエストを実行
        task.resume()
    }
    
    func switchJson(flg: String, json: [String : Any]) {
        switch flg {
            case "login":
                DispatchQueue.main.async {
                    if let token = json["data"] as? String {
                        self.token = token as String
                        self.saveToken(token: token)
                        self.isLogin = true
                        self.fetchData(apiFlg: "mail")
                    } else {
                        self.error = true
                        self.saveToken(token: "")
                    }
                }
            
            case "register":
                DispatchQueue.main.async {
                    if let token = json["data"] as? String {
                        self.token = token as String
                        self.saveToken(token: token)
                        self.isRegister = true
                        self.fetchData(apiFlg: "mail")
                    } else {
                        self.error = true
                    }
                }
                
            case "mail":
                DispatchQueue.main.async {
                    // この条件で型変換に成功しているので中身の処理はas!となる
                    if let dataArray = json["data"] as? NSArray {
                        self.mailArray = dataArray as! [[String : Any]]
                    } else {
                        self.error = true
                    }
                }
            case "logout":
                DispatchQueue.main.async {
                    if json["data"] is String {
                        self.saveToken(token: "")
                    } else {
                        self.saveToken(token: "")
                        self.error = true
                    }
                }
                
            case "fcm_token":
                DispatchQueue.main.async {
                    guard json["data"] is String else {
                        self.error = true
                        return
                    }
                }
            
            default:
                DispatchQueue.main.async {
                    self.saveToken(token: "")
                    self.error = true
                }
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
                DispatchQueue.main.async {
                    self.error = true
                    self.saveToken(token: "")
                }
                return ""
        }
    }
    
    func saveToken(token: String) {
        // APIで帰ってきたトークンを保存する
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    func saveFcmToken(token: String) {
        // MEMO guard else これはif文の最初の処理がないときに使おう
        guard UserDefaults.standard.string(forKey: "fcm_token") != nil, UserDefaults.standard.string(forKey: "fcm_token") != "" else {
            UserDefaults.standard.set(token, forKey: "fcm_token")
            self.fcm_token = token
            self.token = UserDefaults.standard.string(forKey: "token") ?? ""
            self.fetchData(apiFlg: "fcm_token")
            return
        }
    }
}
