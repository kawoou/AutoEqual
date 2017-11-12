//
//  AutoEqual.swift
//  AutoEqual
//
//  Created by Kawoou on 2017. 11. 9..
//  Copyright © 2017년 Kawoou. All rights reserved.
//

import Foundation

// MARK: - EquatableType

public protocol InternalEqual {
    func equal(_ other: InternalEqual) -> Bool
}
extension InternalEqual where Self: Equatable {
    public func equal(_ other: InternalEqual) -> Bool {
        guard let o = other as? Self else {
            return false
        }
        return self == o
    }
}


// MARK: - AutoEquatable

public protocol AutoEqual: Equatable, InternalEqual {}

public func == <T: AutoEqual>(lhs: T, rhs: T) -> Bool {
    var lhsProperties = [String: Any]()
    var rhsProperties = [String: Any]()
    findProperties(Mirror(reflecting: lhs), properties: &lhsProperties)
    findProperties(Mirror(reflecting: rhs), properties: &rhsProperties)
    
    return lhsProperties == rhsProperties
}


// MARK: - Array Support

public func == <T>(lhs: [T]?, rhs: [T]?) -> Bool {
    guard let lhs = lhs else { return false }
    guard let rhs = rhs else { return false }
    
    guard lhs.count == rhs.count else { return false }
    return lhs.enumerated().first { !checkEqual($0.element, rhs[$0.offset]) } == nil
}
public func != <T>(lhs: [T]?, rhs: [T]?) -> Bool {
    return !(lhs == rhs)
}


// MARK: - Dictionary Support

public func == <T, U>(lhs: [T: U]?, rhs: [T: U]?) -> Bool {
    guard let lhs = lhs else { return false }
    guard let rhs = rhs else { return false }
    
    guard Array(lhs.keys) == Array(rhs.keys) else { return false }
    return lhs.first { !checkEqual($0.value, rhs[$0.key]) } == nil
}
public func != <T, U>(lhs: [T: U]?, rhs: [T: U]?) -> Bool {
    return !(lhs == rhs)
}


// MARK: - Private

private func findProperties(_ mirror: Mirror, properties: inout [String: Any]) {
    if let superMirror = mirror.superclassMirror {
        findProperties(superMirror, properties: &properties)
    }
    
    for attr in mirror.children {
        if let propertyName = attr.label as String! {
            properties[propertyName] = attr.value
        }
    }
}

private func checkEqual(_ lhs: Any?, _ rhs: Any?) -> Bool {
    guard let lhs = lhs else { return rhs == nil }
    guard let rhs = rhs else { return false }
    
    /// Array Type
    if let lhs = lhs as? Array<Any>, let rhs = rhs as? Array<Any> {
        return lhs == rhs
    }
    
    /// Dictionary Type
    if let lhs = lhs as? Dictionary<AnyHashable, Any>, let rhs = rhs as? Dictionary<AnyHashable, Any> {
        return lhs == rhs
    }
    
    /// InternalEqual Type
    if let lhs = lhs as? InternalEqual, let rhs = rhs as? InternalEqual {
        return lhs.equal(rhs)
    }
    
    let lhsMirror = Mirror(reflecting: lhs)
    let rhsMirror = Mirror(reflecting: rhs)
    
    /// Optional Type
    if lhsMirror.displayStyle == .optional && rhsMirror.displayStyle == .optional {
        let lhsValue = lhsMirror.children.first?.value
        let rhsValue = rhsMirror.children.first?.value
        
        return checkEqual(lhsValue, rhsValue)
    }
    
    /// Tuple Type
    if lhsMirror.displayStyle == .tuple && rhsMirror.displayStyle == .tuple {
        var lhsProperties = [String: Any]()
        var rhsProperties = [String: Any]()
        findProperties(lhsMirror, properties: &lhsProperties)
        findProperties(rhsMirror, properties: &rhsProperties)
        
        return lhsProperties == rhsProperties
    }
    
    /// Function Type
    if String(describing: lhs) == "(Function)" && String(describing: rhs) == "(Function)" {
        return true
    }
    
    let className = String(describing: lhsMirror.subjectType)
    assertionFailure("\(className) does not implemented `EquatableType` protocol.")
    return false
}


// MARK: - Extensions

/// Integer
extension Int: InternalEqual {}
extension Int8: InternalEqual {}
extension Int16: InternalEqual {}
extension Int32: InternalEqual {}
extension Int64: InternalEqual {}
extension UInt: InternalEqual {}
extension UInt8: InternalEqual {}
extension UInt16: InternalEqual {}
extension UInt32: InternalEqual {}
extension UInt64: InternalEqual {}

/// Floating Point
extension Float: InternalEqual {}
extension Float80: InternalEqual {}
extension Double: InternalEqual {}

/// Boolean
extension Bool: InternalEqual {}

/// String
extension String: InternalEqual {}
extension Character: InternalEqual {}

/// Range
extension ClosedRange: InternalEqual {}
extension CountableClosedRange: InternalEqual {}
extension CountableRange: InternalEqual {}
extension Range: InternalEqual {}

/// Others
extension Set: InternalEqual {}
extension Date: InternalEqual {}

/// ObjectiveC
extension NSValue: InternalEqual {}
extension NSString: InternalEqual {}
extension NSDate: InternalEqual {}
