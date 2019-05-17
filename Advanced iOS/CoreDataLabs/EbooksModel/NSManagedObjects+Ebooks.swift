// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import CoreData

extension NSManagedObject
{
    public convenience init(dictionary: [String: Any], context: NSManagedObjectContext) {
        self.init(context: context)
        self.setValuesForKeys(dictionary)
    }
    
    open func saveIfNeeded() throws {
        if hasPersistentChangedValues {
            try managedObjectContext?.save()
        }
    }
}
