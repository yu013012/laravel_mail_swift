//
//  UITests.swift
//  UITests
//
//  Created by 丹羽悠 on 2023/11/02.
//

import XCTest

@testable import laravel_mail

final class laravel_mailUITests: XCTestCase {
    
    // プロジェクトをクリックして上のEditorからadd targetをクリックして、testを選択し追加。
    // 選択できるテストの違い
    // 作成されたファイルの違い
    // これ何
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    // これ何
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // ファンクションの前にtestをつける
    func testログイン失敗() throws {
        // XCUIApplication オブジェクトを使用して、アプリケーションの操作を模倣します。
        let app = XCUIApplication()
        app.launch()
        
        // ログインと表示されたボタンを変数に格納
        let button = app.buttons["ログイン"]
        // ボタンをクリック
        button.tap()
        
        // Alertが表示されたことを確認、念のため10秒待機(エラーというタイトルで中の説明がエラーが発生しました。アプリを終了して再度お試しください。)
        let exists = app.alerts["エラー"].staticTexts["エラーが発生しました。アプリを終了して再度お試しください。"].waitForExistence(timeout: 10)
        // 上記の真偽の確認
        XCTAssertTrue(exists)
    }
    
    func testログイン成功() throws {
        // XCUIApplication オブジェクトを使用して、アプリケーションの操作を模倣します。
        let app = XCUIApplication()
        app.launch()
        
        let button = app.buttons["ログイン"]
        
        let textField = app.textFields["メールアドレス"]
        textField.tap()
        textField.typeText("youdanyu943@gmail.com")
        
        app.tap()
        
        let secureTextFields = app.secureTextFields["パスワード"]
        secureTextFields.tap()
        secureTextFields.typeText("0130Yu12")
        // 改行を入れるとキーボードを閉じれる
        secureTextFields.typeText("\n")
        
        // ボタンが表示されるまでスクロール(ボタンがなかったらループでスクロール)
//        while !button.exists {
//            app.swipeDown() // 画面を上にスワイプしてスクロール
//        }

        // ボタンが見つかったらタップする
        if button.exists {
            button.tap()
        }
        
        // waitForExistenceはexistの待機バージョン、リターン値はBool
        // buttonの中のimageでidを設定しているが、その場合は親のviewにidが適用される
        // このほかにsleep(10)でもやる方法がある。
        let menuIconImage = app.buttons["menuIconImage"]
        XCTAssertTrue(menuIconImage.waitForExistence(timeout: 10))
    }
}
