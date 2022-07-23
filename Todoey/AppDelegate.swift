//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().barTintColor = .systemBlue
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            _ = try Realm()
        } catch {
            print(error)
        }
        
        return true
    }
    
}

