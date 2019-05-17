// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import CoreData

class ModelController: NSObject
{
    lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: type(of: self))
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Unable to load managed object model.")
        }
        return mom
    }()
    
//    lazy var persistentStoreDescription: NSPersistentStoreDescription = {
//        let description = NSPersistentStoreDescription(url: url)
//        description.shouldMigrateStoreAutomatically = shouldMigrateStoreAutomatically
//        description.shouldInferMappingModelAutomatically = shouldInferMappingModelAutomatically
//        description.shouldAddStoreAsynchronously = shouldAddStoreAsynchronously
//        description.isReadOnly = isReadOnly
//        return description
//    }()
    
    var container: NSPersistentContainer!
    
    
}



