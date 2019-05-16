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

//extension AppDelegate
//{
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let touchedView = touch.view else { return }
//        
//        let currLocation = touch.location(in: nil)
//        let prevLocation = touch.previousLocation(in: nil)
//        
//        touchedView.center.x += currLocation.x - prevLocation.x
//        touchedView.center.y += currLocation.y - prevLocation.y
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { }
//}

extension AppDelegate
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("In \(AppDelegate.self), \(#function)")
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
