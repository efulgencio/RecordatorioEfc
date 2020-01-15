//
//  AppDelegate.swift
//  RecordatorioEfc
//
//  Created by eduardo fulgencio on 10/01/2020.
//  Copyright © 2020 Eduardo Fulgencio Comendeiro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "initialVCid") as! InitialVC
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler:
                                                            @escaping (UIBackgroundFetchResult) -> Void) {
        CLService.shared.updateLocation()
    }
    


    

    
}



