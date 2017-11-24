//
//  CCXExtensions.swift
//  StORM
//
//  Created by Ryan Coyne on 11/22/17.
//

import Foundation

//MARK: - Optionals
extension Optional {
    /// This returns whether or not the optional is equal to nil.
    var isNil : Bool {
        return self == nil
    }
    /// This returns whether or not the optional is not equal to nil.
    var isNotNil : Bool {
        return self != nil
    }
    /// This returns the optional unwrapped into a boolean value.
    var boolValue : Bool? {
        if self.isNil {
            return nil
        }
        switch self {
        case is String, is String?:
            return Bool(self as! String)
        case is Int, is Int?:
            return Bool(self as! Int)
        default:
            return nil
        }
    }
    /// This returns the optionally wrapped object as a string value.
    var stringValue : String? {
        return self as? String
    }
    /// This returns the optionally wrapped object as a dictionary value.
    var dicValue : [String:Any]! {
        return self as? [String:Any] ?? [:]
    }
    /// This returns the optionally wrapped object as an array of dictionaries...value.
    var arrayDicValue : [[String:Any]]! {
        return self as? [[String:Any]] ?? [[:]]
    }
    /// This returns the optionally wrapped object as an integer value.
    var intValue : Int? {
        return self as? Int
    }
    /// This returns the optionally wrapped object as a double value.
    var doubleValue : Double? {
        return self as? Double
    }
    /// This returns the optionally wrapped object as a float value.
    var floatValue : Float? {
        return self as? Float
    }
    /// This returns the optionally wrapped object as a URL value.
    var urlValue : URL? {
        if self.isNil {
            return nil
        }
        switch self {
        case is String, is Optional<String>:
            return URL(string: self.stringValue!)
        case is URL, is URL?:
            return self as? URL
        default:
            return nil
        }
    }
}
//MARK: - Boolean
extension Bool {
    init(_ integerValue : Int) {
        if integerValue == 0 {
            self.init(false)
        } else {
            self.init(true)
        }
    }
}
//MARK: - Mirror Array:
extension Array where Iterator.Element == Mirror {
    func allChildren(includingNilValues: Bool=false) -> [Mirror.Child] {
        var allChild : [Mirror.Child] = []
        for mirror in self {
            mirror.children.forEach({ (child) in
                // Make sure our child has a label & the string describing the value is not nil. (Making optionals supported)
                if !includingNilValues {
                    if child.label.isNotNil, String(describing: child.value) != "nil" {
                        allChild.append(child)
                    }
                } else {
                    if child.label.isNotNil {
                        allChild.append(child)
                    }
                }
            })
        }
        // Lets make sure if the primaryKey is set, it is the first object:
        if let keyLabel = StORM.primaryKeyLabel, allChild.first?.label != keyLabel {
            if let index = allChild.index(where: { (child) -> Bool in
                return child.label.isNotNil && child.label == StORM.primaryKeyLabel!
            }) {
                allChild.remove(label: keyLabel)
                let idChild = allChild[index]
                allChild.insert(idChild, at: 0)
            }
        }
        return allChild
    }
}

extension Array where Iterator.Element == Mirror.Child {
    mutating func remove(label : String) {
        if let index = self.index(where: { (child) -> Bool in
            return child.label.isNotNil && child.label == StORM.primaryKeyLabel
        }) {
            self.remove(at: index)
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    public func asData() -> [(String, Any)] {
        var data : [(String,Any)] = []
        for row in self {
            data.append(row)
        }
        return data
    }
}
