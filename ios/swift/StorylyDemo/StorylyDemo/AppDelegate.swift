//
//  AppDelegate.swift
//  StorylyDemo
//
//  Created by Levent ORAL on 25.09.2019.
//  Copyright © 2019 App Samurai Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        StorylyConfiguration.shared.onStoryUrlDeepLinkHandle(url)
        return true
    }
}

enum StorylyConstans {
    static let groupUrlKey = "g"
    static let storyUrlKey = "s"
}

final class StorylyConfiguration {
    static let shared = StorylyConfiguration()
    
    var groupId: String?
    var storyId: String?
    
    func onStoryUrlDeepLinkHandle(_ url: URL) {
        groupId = url.valueOf(StorylyConstans.groupUrlKey)
        storyId = url.valueOf(StorylyConstans.storyUrlKey)
        let object = [StorylyConstans.groupUrlKey: groupId, StorylyConstans.storyUrlKey: storyId]
        
        NotificationCenter.default.post(name: .OpenStorylyItem, object: object)
    }
    
    func onStoryNotificationHandle(notification: Notification, completion: @escaping(_ groupId: String, _ storyId: String?) -> Void) {
        guard let events = notification.object as? [String: String] else { return }
        guard let groupId = events[StorylyConstans.groupUrlKey] else { return }
        let storyId = events[StorylyConstans.storyUrlKey]
        completion(groupId, storyId)
    }
}

extension NSNotification.Name {
    static let OpenStorylyItem = Notification.Name("OpenStorylyItem")
}


extension URL {
    static var documents: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
