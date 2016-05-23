// 
// Copyright (c) 2015 Big Nerd Ranch
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let rootViewController = window!.rootViewController as! UINavigationController
        let photosViewController = rootViewController.topViewController as! PhotosViewController
        photosViewController.store = PhotoStore()
        
        return true
    }

    

}

