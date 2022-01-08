import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var deviceTokenString = ""
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let METHOD_CHANNEL_NAME = "p3s.com/methods";
    let batteryChannel = FlutterMethodChannel(
        name:METHOD_CHANNEL_NAME,
        binaryMessenger:controller.binaryMessenger)
    
    batteryChannel.setMethodCallHandler({
        (call: FlutterMethodCall,result: @escaping FlutterResult) -> Void in
        switch call.method {
            case "getBatteryLevel":
                guard let args = call.arguments as? [String:String] else {return}
                let name = args["name"]!

                result(self.receiveBatteryLevel())
            case "requestPush":
                self.requestPush()
                result(true)
            case "schedulePush":
                self.schedulePush()
                result(true)
            case "tokenPush":
                result(self.tokenPush())
            default:
                result(FlutterMethodNotImplemented)
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func receiveBatteryLevel() -> Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        if device.batteryState == UIDevice.BatteryState.unknown {
            return -1
        }else{
            return Int(device.batteryLevel * 100)
        }
    }
    
    private func requestPush()  {
       if #available(iOS 10.0, *) {
    //iOS 10.0 and greater
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { granted, error in
        DispatchQueue.main.async {
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
            else {
                //Do stuff if unsuccessful...
            }
        }
   })
}
else { 
    //iOS 9
    let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
    let setting = UIUserNotificationSettings(types: type, categories: nil)
    UIApplication.shared.registerUserNotificationSettings(setting)
    UIApplication.shared.registerForRemoteNotifications()
    

}

    }

    private func schedulePush(){
        if #available(iOS 10.0, *) {
    //iOS 10 or above version
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = .default
    content.categoryIdentifier = "replyCategory"
            
    // notification action
    let replyAction = UNNotificationAction(
        identifier: "reply_action", title: "snova",
        options: UNNotificationActionOptions.init(rawValue: 0)
    )
    
    let actionCategory = UNNotificationCategory(
    identifier: "replyCategory", actions: [replyAction], intentIdentifiers: [], options:
        .customDismissAction
    )
    center.setNotificationCategories([actionCategory])
    var dateComponents = DateComponents()
    dateComponents.hour = 11
    dateComponents.minute = 45
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
} else {
    // ios 9 
    let notification = UILocalNotification()
    notification.alertAction = "OK"
    notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
    notification.userInfo = ["title": "Confirm", "UUID": UUID().uuidString, "CallIn": "CallInNotification"]
    notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
    notification.alertAction = "be awesome!"
    notification.category = "CALLINNOTIFICATION"
    notification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.shared.scheduleLocalNotification(notification)
}
    }  

    private func tokenPush() -> String {
        return deviceTokenString
       
    }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        deviceTokenString = token
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        deviceTokenString = ""
    }

}


