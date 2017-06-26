//
//  AppDelegate.swift
//  ObservableSample
//
//  Created by devtak on 2017. 6. 12..
//  Copyright © 2017년 devtak. All rights reserved.
//

import UIKit

protocol AppDelegateEvent {
    func appDelegateEnterBackground()
    func appDelegateEnterForground()
}

extension AppDelegateEvent {
    func appDelegateEnterBackground() {}
    func appDelegateEnterForground() {}
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    fileprivate var _observers: Observable.ObserverContainer = []
    fileprivate var _observersLock: NSRecursiveLock = NSRecursiveLock()
    
    public static var instance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.notify { observer in
            observer.appDelegateEnterBackground()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        self.notify {
            $0.appDelegateEnterForground()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate: Observable {
    var observersLock: NSRecursiveLock? {
        get {
            return self._observersLock
        }
    }
    
    typealias Observer = AppDelegateEvent
    var observers: Observable.ObserverContainer {
        get {
            return self._observers
        }
        set {
            self._observers = newValue
        }
    }
}