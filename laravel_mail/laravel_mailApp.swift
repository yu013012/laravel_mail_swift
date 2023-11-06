//
// laravel_mailApp.swift
// laravel_mail
//
// Created by 丹羽悠 on 2023/08/31.
//

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    // アプリが起動し初期化が完了した時に呼ばれる(didFinishLaunchingWithOptions)、UIApplicationDelegateを適合しているときだけ使える
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 初期設定
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        // 通知権限
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        application.registerForRemoteNotifications()

        Messaging.messaging().token { token, error in
            if let error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token {
                let model = Model()
                model.saveFcmToken(token: String(describing: token))
                print("FCM registration token: \(token)")
            }
        }
        return true
    }

    // リモート通知の登録に失敗したとき
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }

    // リモート通知のデバイストークンが正常に登録されたとき
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                let model = Model()
                model.saveFcmToken(token: token)
                print("FCM registration token: \(token)")
            }
        }
    }
}

// extensionは定義されてあるクラスに処理を追加するために使う
extension AppDelegate: MessagingDelegate {
    // objcはObjective-Cと連携するための宣言。これがあるとObjective-Cからこのメソッドを呼び出せる。
    // なので特にいらない。
    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
    }
}

// 通知の設定、タイトルなど
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"),
            object: nil,
            userInfo: userInfo
        )
        completionHandler()
    }
}

// アプリケーション起動時に@mainが読み込まれる
@main
struct laravel_mailApp: App {
  let model = Model()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {

    WindowGroup {
      ContentView().environmentObject(model)
    }
  }
}
