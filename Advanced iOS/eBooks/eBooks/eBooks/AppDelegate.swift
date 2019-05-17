// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit
import eBooksModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        URLProtocol.registerClass(HttpsProtocol.self)
        registerValueTransformers()
        return true
    }
    
    private func registerValueTransformers() {
        ValueTransformer.setValueTransformer(UrlTransformer(),   forName: UrlTransformer.transformerName)
        ValueTransformer.setValueTransformer(UuidTransformer(),  forName: UuidTransformer.transformerName)
        ValueTransformer.setValueTransformer(ImageTransformer(), forName: ImageTransformer.transformerName)
        ValueTransformer.setValueTransformer(DateTransformer(),  forName: DateTransformer.transformerName)
    }
}

