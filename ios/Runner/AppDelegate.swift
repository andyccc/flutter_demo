import UIKit
import Flutter
import UserNotifications
import AdSupport

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        //【注册通知】通知回调代理（可选）
        let entity = JPUSHRegisterEntity()
        entity.types =  1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        //【初始化sdk】
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "b5a5ad3c715c12a5caa161eb", channel: "App Store", apsForProduction: false, advertisingIdentifier: advertisingId)
        
        if #available(iOS 10.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @available(iOS 10.0, *)
    @objc func networkDidReceiveMessage(notification: Notification) {
        let userInfo = notification.userInfo
        if let extras = userInfo?["extras"] as? Dictionary<String, String> {
            NSLog("extras: \(extras)")
        }
        // 将自定义消息的内容转换成本地推送
        if let con = userInfo?["content"] as? String {
            //设置推送内容
            let content = UNMutableNotificationContent()
            content.body = con

            //设置通知触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)

            //设置请求标识符
            let requestIdentifier = "com.average.Demo"

            //设置一个通知请求
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            //将通知请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            }
        }
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
        
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //可选
        NSLog("did Fail To Register For Remote Notifications With Error: \(error)")
    }
}

extension AppDelegate: JPUSHRegisterDelegate {
    // MARK: JPUSHRegisterDelegate
    // iOS 10 Support
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        
    }
    
    // iOS 10 Support
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 系统要求执行这个方法
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
    
    
    
}


