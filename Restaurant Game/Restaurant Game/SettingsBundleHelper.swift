//
//  SettingsBundleHelper.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/17/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    
    //check whether it is the first time launching the app
    class func isAppAlreadyLaunchedOnce() {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            //print("App already launched : \(isAppAlreadyLaunchedOnce)")
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            defaults.register(defaults: [
                "dev_name" : "orin_xie",
                ])
            defaults.set(Date(), forKey: "initial_launch")
            //print(defaults.object(forKey: "initial_launch"))
            //print("App launched first time")
        }
    }
}
