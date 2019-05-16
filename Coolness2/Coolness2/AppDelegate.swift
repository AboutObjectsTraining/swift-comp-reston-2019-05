// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("In \(#function)")
        
        window = UIWindow()
        window?.backgroundColor = UIColor.yellow
        window?.rootViewController = CoolController(nibName: "CoolStuff", bundle: nil)

        window?.makeKeyAndVisible()
    }
}

extension AppDelegate
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("In \(AppDelegate.self), \(#function)")
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
