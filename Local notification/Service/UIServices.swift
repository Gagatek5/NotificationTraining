//
//  UIServices.swift
//  Local notification
//
//  Created by Tom on 17/03/2018.
//  Copyright © 2018 Tom. All rights reserved.
//

import Foundation
import UserNotifications

class UNServices: NSObject {
    
    private override init() {}
    static let shared = UNServices()
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let option: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: option){ (granted, error) in
            print(error ?? "No Error")
            guard granted else {
                print("USER DENIED ACCESS")
                return
            }
            
            self.configure()
        }

    }
    func configure() {
        unCenter.delegate = self
        setupActiuonsAndCategories()
    }
    
    func setupActiuonsAndCategories()
    {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue,
                                               title: "run timer logic",
                                               options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue,
                                               title: "run date logic",
                                               options: [.destructive])
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue,
                                               title: "run location logic",
                                               options: [.foreground])
        
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue,
                                                   actions: [timerAction],
                                                   intentIdentifiers: [])
        let dateCategory =  UNNotificationCategory(identifier: NotificationCategory.date.rawValue,
                                                   actions: [dateAction],
                                                   intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue,
                                                      actions: [locationAction],
                                                      intentIdentifiers: [])
                unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func getAttachment(for id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer:
            imageName = "TimeAlert"
        case .date:
            imageName = "DateAlert"
        case .location:
            imageName = "LocationAlert"
        }
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        do {
            let attahment = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attahment
        } catch {
            return nil
        }
        
    }
    
    func timerRequest(with interval: TimeInterval)
    {
        let content = UNMutableNotificationContent()
        content.title = "TimerFinish"
        content.body = "YourTimer is all done. YAY!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        
        if let attachment = getAttachment(for: .timer) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
        unCenter.add(request)
    }
    func dateRequest(with date: DateComponents)
    {
        let content = UNMutableNotificationContent()
        content.title = "Date trigger "
        content.body = "It is now the future"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        if let attachment = getAttachment(for: .date) {
            content.attachments = [attachment]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        unCenter.add(request)
    }
    func locationRequest()
    {
        let content = UNMutableNotificationContent()
        content.title = "You have return"
        content.body = "Welcome back"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.location.rawValue
        
        if let attachment = getAttachment(for: .location) {
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
    
    
}

extension UNServices: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did recived reponse")
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier){
            
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"), object: action)
            
        }
        
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let option: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(option)
    }
    
}
