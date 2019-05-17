//
// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import Foundation
import CoreData

public enum MappingError: Error {
    case unknownRelationship(String)
}

/// A managed object capable of encoding itself to, and decoding itself from, JSON,
/// using attribute and relationship descriptions supplied by its `NSEntityDescription`.
///
@objc(ManagedObject)
open class ManagedObject : NSManagedObject
{
    override public required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    /// Returns a clone of `self` and its attributes (but not its relationships).
    ///
    /// - Parameters:
    /// - context: context into which to insert the clone
    /// - Returns: a new managed object
    open func shallowCloned(insertInto context: NSManagedObjectContext?) -> ManagedObject {
        let clone = type(of: self).init(entity: self.entity, insertInto: context) as ManagedObject
        clone.decodeAttributeValues(dictionaryRepresentation)
        return clone
    }
}

// MARK: - Encoding
extension ManagedObject
{
    /// Returns a dictionary of the encoded values any properties of `self` that
    /// are modeled as attributes or relationships in this object's `NSEntityDescription`.
    ///
    /// - Returns: a dictionary of encoded property values
    open var dictionaryRepresentation: JsonDictionary {
        return encodedValues(parent: self)
    }
    
    /// Returns a dictionary of the encoded values any properties of `self` that
    /// are modeled as attributes or relationships in this object's `NSEntityDescription`.
    ///
    /// - Note: If a relationship's `userInfo` dictionary has an entry named **jsonKeyPath**,
    ///         the keys in the returned dictionary will be based on that rather than
    ////        the value of the relationship's `keyPath` property.
    ///
    /// - Parameter parent: object that owns `self`, or `nil`
    /// - Returns: a dictionary of encoded property values
    open func encodedValues(parent: ManagedObject?) -> JsonDictionary {
        let dict = NSMutableDictionary()
        for (key, value) in encodedRelationshipValues(parent: parent) { dict[key] = value }
        for (_, attribute) in entity.attributesByName { addEncodedValue(forAttribute: attribute, toDictionary: dict, keyPath: attribute.keyPath) }
        guard let jsonDict = dict.copy() as? JsonDictionary else { fatalError("Unable to convert NSMutableDictionary to JsonDictionary") }
        return jsonDict
    }
    
    // MARK: - Encoding attribute values
    
    /// Encodes the value of the property identified by `keyPath`, and adds it
    /// to `encodedValues`. Adds any nested dictionaries, if absent, needed to model
    /// the structure implied by intervening keypath elements.
    ///
    /// - Parameters:
    ///   - attribute: description of the property to encode
    ///   - encodedValues: currently encoded values of `self`
    ///   - keyPath: path of the property to encode
    open func addEncodedValue(forAttribute attribute: NSAttributeDescription, toDictionary encodedValues: NSMutableDictionary, keyPath: String) {
        var currDict = encodedValues
        let keys = keyPath.keyPathComponents
        for index in 0..<keys.count - 1 {
            let newDict = NSMutableDictionary()
            currDict[keys[index]] = newDict
            currDict = newDict
        }
        
        if let lastKey = keys.last {
            addEncodedValue(forAttribute: attribute, toDictionary: currDict, key: lastKey)
        }
    }
    
    /// Encodes the value of the property identified by `key`, and adds it
    /// to `encodedValues`. If an `NSValueTransformer` is configured for `attribute`,
    /// the value is transformed, and the transformed value is added to `encodedValues` instead.
    ///
    /// - Parameters:
    ///   - attribute: description of the property to encode
    ///   - encodedValues: currently encoded values of `self`
    ///   - key: name of the property to encode
    open func addEncodedValue(forAttribute attribute: NSAttributeDescription, toDictionary encodedValues: NSMutableDictionary, key: String) {
        var value = self.value(forKey: attribute.name)
        if  let val = value,
            let transformerName = attribute.valueTransformerName,
            let transformer = ValueTransformer(forName: NSValueTransformerName(rawValue: transformerName))
        {
            if let stringTransformer = transformer as? StringTransformable {
                value = stringTransformer.stringValue(val)
            }
            else {
                value = transformer.transformedValue(val)
            }
        }
        
        encodedValues[key] = value ?? NSNull()
    }
    
    // MARK: - Encoding relationship values
    
    /// Returns a dictionary containing the encoded values of any properties
    /// defined as relationships in the `NSEntityDescription` for `self`.
    ///
    /// - Parameter parent: object that owns `self`
    /// - Returns: encoded relationship values keyed by relationship name
    open func encodedRelationshipValues(parent: ManagedObject?) -> JsonDictionary
    {
        let encodedVals: NSMutableDictionary = NSMutableDictionary()
        for (_, relationship) in entity.relationshipsByName {
            if !relationship.isToMany && (parent == nil || relationship.isReverse(to: parent)) {
                continue
            }
            let val = encodedValue(forRelationship: relationship, parent: parent)
            encodedVals.setValue(val, forKey: relationship.keyPath)
        }
        
        return encodedVals.copy() as? JsonDictionary ?? [:]
    }

    /// Encodes the value of the property described by `relationship`.
    ///
    /// - Parameters:
    ///   - relationship: description of the property to encode
    ///   - parent: object that owns `self`
    /// - Returns: the encoded property value
    open func encodedValue(forRelationship relationship: NSRelationshipDescription, parent: ManagedObject?) -> AnyObject
    {
        guard let value = value(forKey: relationship.name), !(value is NSNull) else { return NSNull() }
        
        return relationship.isToMany ?
            encodedToManyRelationship(value: value) :
            encodedToOneRelationship(value: value, relationship: relationship, parent: parent)
    }
    
    /// Returns a dictionary representation of `value` if non-nil; otherwise
    /// returns an `NSNull`.
    ///
    /// - Parameters:
    ///   - value: a model object
    ///   - relationship: description of a to-one relationship
    ///   - parent: parent of the provided model object
    /// - Returns: an encoded model object
    open func encodedToOneRelationship(value: Any, relationship: NSRelationshipDescription, parent: ManagedObject?) -> AnyObject {
        guard let managedObj = value as? ManagedObject else { return NSNull() }
        return managedObj.encodedValues(parent: parent) as AnyObject
    }
    
    /// If `value` is an instance of `NSSet`, `NSOrderedSet`, or is an array of
    /// model objects, returns an array of dictionary representations of `value`'s
    /// contents; otherwise, returns an `NSNull`.
    ///
    /// - Parameter value: an array of encoded model objects
    /// - Returns: a dictionary
    open func encodedToManyRelationship(value: Any) -> AnyObject {
        switch value {
        case let managedObjs as NSSet:           return managedObjs.dictionaryRepresentation as AnyObject
        case let managedObjs as NSOrderedSet:    return managedObjs.dictionaryRepresentation as AnyObject
        case let managedObjs as [ManagedObject]: return managedObjs.dictionaryRepresentation as AnyObject
        default: return NSNull()
        }
    }
}

// MARK: - Decoding
extension ManagedObject
{
    /// Overrides the inherited method to convert `NSNull` values to `nil`.
    ///
    /// - Parameters:
    ///   - value: the value to be set
    ///   - key: a key describing a property
    open override func setValue(_ value: Any?, forKey key: String)
    {
        let val = (value is NSNull ? nil : value)
        super.setValue(val, forKey: key)
    }
    
    /// Calls `decodeRelationshipValues()` and `decodeAttributeValues()` to decode
    /// values from the provided dictionary.
    ///
    /// - Parameter dictionary: values to be decoded
    open func decode(from dictionary: JsonDictionary) {
        decodeRelationshipValues(dictionary)
        decodeAttributeValues(dictionary)
    }
    
    /// Decodes attribute values from the provided dictionary by calling
    /// `decode(_:forAttribute:)` for each of the attributes
    /// defined in the object's `NSEntityDescription`.
    ///
    /// - Parameter dictionary: attribute values to be decoded
    open func decodeAttributeValues(_ dictionary: JsonDictionary)
    {
        for (_, attribute) in entity.attributesByName {
            let val = (dictionary as NSDictionary).value(forKeyPath: attribute.keyPath)
            decode(val as AnyObject?, forAttribute: attribute)
        }
    }
    
    /// Decodes relationship values from the provided dictionary -- by calling
    /// `setObject(forRelationship:withValuesFromDictionary:)` for to-one related
    /// objects, and `addObjects(toRelationship:withValuesFromDictionaries:)` for
    /// to-many related objects -- for each of the relationships defined in the
    /// object's `NSEntityDescription`.
    ///
    /// - Parameter dictionary: relationship values to be decoded
    open func decodeRelationshipValues(_ dictionary: JsonDictionary)
    {
        for (_, relationship) in entity.relationshipsByName {
            if let val = (dictionary as NSDictionary).value(forKeyPath: relationship.keyPath) {
                if let dicts = val as? [JsonDictionary], relationship.isToMany {
                    addObjects(toRelationship: relationship, withValuesFromDictionaries: dicts)
                }
                else if let dict = val as? JsonDictionary, value(forKey: relationship.name) == nil {
                    setObject(forRelationship: relationship, withValuesFromDictionary: dict)
                }
            }
        }
    }
    
    /// Sets the value for the provided attribute to `value`. If an `NSValueTransformer`
    /// is registered for the attribute, the value is transformed prior to being
    /// set.
    ///
    /// - Parameters:
    ///   - value: value to decode
    ///   - attribute: description of the attribute to be set
    open func decode(_ value: AnyObject?, forAttribute attribute: NSAttributeDescription)
    {
        var newValue = value
        
        if let value = value, value !== NSNull(),
            let transformerName = attribute.valueTransformerName,
            let transformer = ValueTransformer(forName: NSValueTransformerName(rawValue: transformerName)) {
            if let stringTransformer = transformer as? StringTransformable {
                newValue = stringTransformer.objectValue(value) as AnyObject? ?? NSNull()
            }
            else {
                newValue = transformer.reverseTransformedValue(value) as AnyObject? ?? NSNull()
            }
        }
        setValue(newValue, forKey: attribute.name)
    }
    
    /// Populates the collection corresponding to `relationship` with managed objects decoded
    /// from `dictionaries` by calls to `managedObject(withDictionary:relationship:)`. For
    /// inverse relationships, also sets a back pointer to `self` in each managed
    /// object it decodes.
    ///
    /// - Parameters:
    ///   - relationship: relationship to decode
    ///   - dictionaries: keys and values of the objects to be decoded
    open func addObjects(toRelationship relationship: NSRelationshipDescription, withValuesFromDictionaries dictionaries: [JsonDictionary])
    {
        let managedObjects = dictionaries.map { dict -> ManagedObject in
            let managedObj = managedObject(withDictionary: dict, relationship: relationship)
            if let key = relationship.inverseRelationship?.name {
                managedObj.setPrimitiveValue(self, forKey: key)
            }
            return managedObj
        }
        let set = relationship.isOrdered ? NSOrderedSet(array: managedObjects) : NSSet(array: managedObjects)
        setPrimitiveValue(set, forKey: relationship.name)
    }
    
    /// Populates a property corresponding to `relationship` with a managed object decoded
    /// from the provided dictionary by calling `managedObject(withDictionary:relationship:)`.
    /// For inverse relationships, also sets a back pointer to `self` in the decoded object.
    ///
    /// - Parameters:
    ///   - relationship: relationship to decode
    ///   - dictionaries: keys and values of the object to be decoded
    open func setObject(forRelationship relationship: NSRelationshipDescription, withValuesFromDictionary dictionary: JsonDictionary)
    {
        var dict = dictionary
        if let nestedDict = (dictionary as NSDictionary).value(forKeyPath: relationship.keyPath) as? JsonDictionary {
            dict = nestedDict
        }
        
        let managedObj = managedObject(withDictionary: dict, relationship: relationship)
        if let key = relationship.inverseRelationship?.name {
            managedObj.setValue(self, forKey: key)
        }
        setPrimitiveValue(managedObj, forKey: relationship.name)
    }
    
    /// Returns a new to-one or to-many related managed object decoded from `dictionary`.
    /// provided relationship description.
    ///
    /// - Parameters:
    ///   - dictionary: keys and values of the object to be decoded
    ///   - relationship: description of the relationship
    /// - Returns: a new managed object
    open func managedObject(withDictionary dictionary: JsonDictionary, relationship: NSRelationshipDescription) -> ManagedObject
    {
        guard let targetEntity = relationship.destinationEntity,
            let className = targetEntity.managedObjectClassName,
            let targetClass: ManagedObject.Type = NSClassFromString(className) as? ManagedObject.Type
            else {
                print("Unable to resolve target class for \(String(describing: relationship.destinationEntity))")
                abort() // TODO: Switch to throwing implementation
        }
        
        let newObject = targetClass.init(entity: targetEntity, insertInto: managedObjectContext)
        newObject.decode(from: dictionary)
        return newObject
    }
}


// MARK: - Setting/Adding Child Model Objects Programmatically
//
// Not currently in use.
extension ManagedObject
{
    open func relationship(forKey key: String) -> NSRelationshipDescription? {
        return entity.relationshipsByName[key]
    }
    
    open func add(managedObject: ManagedObject, forKey key: String) throws {
        try self.add(managedObjects: [managedObject], forKey: key)
    }
    
    open func add(managedObjects: [ManagedObject], forKey key: String) throws {
        guard let relationship = relationship(forKey: key) else { throw MappingError.unknownRelationship(key) }
        if let inverseKey = relationship.inverseRelationship?.name {
            for managedObj in managedObjects {
                managedObj.setValue(self, forKey: inverseKey)
            }
        }
        if value(forKey: key) == nil {
            setValue(managedObjects, forKey: key)
            return
        }
        mutableArrayValue(forKey: key).addObjects(from: managedObjects)
    }
    
    open func set(managedObject: ManagedObject, forKey key: String) throws {
        guard let relationship = relationship(forKey: key) else { throw MappingError.unknownRelationship(key) }
        if let inverseKey = relationship.inverseRelationship?.name {
            managedObject.setValue(self, forKey: inverseKey)
        }
        setValue(managedObject, forKey: relationship.name)
    }
}

// MARK: - KVC Customization
//
// Not currently in use.
extension ManagedObject
{
    class var kvcPrefix: String { return "kvc_" }
    
    override open func setNilValueForKey(_ key: String) {
        if !key.hasPrefix(ManagedObject.kvcPrefix) {
            super.setNilValueForKey(key)
        }
        // Silently ignore prefixed keys, so if we're initializing a new instance,
        // the property value will remain .None.
    }
    
    override open func value(forUndefinedKey key: String) -> Any? {
        return key.hasPrefix(ManagedObject.kvcPrefix) ? nil : super.value(forKey: ManagedObject.kvcPrefix + key)
    }
    
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key.hasPrefix(ManagedObject.kvcPrefix) {
            super.setValue(value, forUndefinedKey: key)
        } else {
            super.setValue(value, forKey: ManagedObject.kvcPrefix + key)
        }
    }
}
