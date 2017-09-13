//
//  AppDelegate.swift
//  LeJia
//
//  Created by 王嘉宁 on 2017/5/8.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func setUpAPIKey() {
        AMapServices.shared().apiKey = LJ.AMapAPIKey
        IFlySpeechUtility.createUtility(LJ.IFlyAPIKey)
    }

    func setUpSlideMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        let refuelViewController = RefuelViewController()
        let refuelNavViewController = UINavigationController(rootViewController: refuelViewController)
        
        let musicViewController = MusicViewController()
        
        let carInfoViewController = CarInfoViewController()
        let carInfoNavViewController = UINavigationController(rootViewController: carInfoViewController)
        
        let lifestyleViewController = LifestyleViewController()
        let lifestyleNaviViewController = UINavigationController(rootViewController: lifestyleViewController)
        
        let data: [[(UIImage, String, UIViewController)]]
            = [[(#imageLiteral(resourceName: "left_icon_map"), "地图导航", mainViewController),
                     (#imageLiteral(resourceName: "left_icon_refuel"), "预约加油", refuelNavViewController),
                     (#imageLiteral(resourceName: "left_icon_music"), "音乐电台", musicViewController),
                     (#imageLiteral(resourceName: "left_icon_car"), "车辆信息", carInfoNavViewController),
                     (#imageLiteral(resourceName: "left_icon_lifestyle"), "乐驾生活", lifestyleNaviViewController)]]
        
        
        let leftViewController = LeftViewController(data: data)
        
        // 设置语音控制
        SpeechManager.mainViewController = mainViewController
        SpeechManager.refuelNaviViewController = refuelNavViewController
        SpeechManager.refuelViewController = refuelViewController
        SpeechManager.musicViewController = musicViewController
        SpeechManager.carInfoNaviViewController = carInfoNavViewController
        SpeechManager.carInfoViewController = carInfoViewController
        SpeechManager.lifestyleNaviViewController = lifestyleNaviViewController
        SpeechManager.lifestyleViewController = lifestyleViewController
        SpeechManager.leftViewController = leftViewController
        
        
        let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpAPIKey()
        setUpSlideMenu()
        
        // 用上次登录的信息登录
        UserManager.shared.logInWithLastTimeInfo()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LeJia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

