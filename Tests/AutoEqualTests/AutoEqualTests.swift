//
//  AutoEqualTests.swift
//  AutoEqualTests
//
//  Created by Kawoou on 2017. 11. 9..
//  Copyright © 2017년 Kawoou. All rights reserved.
//

import XCTest
@testable import AutoEqual

private func random<T>() -> T where T: FixedWidthInteger {
    if T.min == 0 {
        let a = UInt64(arc4random())
        let b = a % UInt64(T.max)
        return T(b)
    } else {
        let a = Int64(arc4random())
        let b = a + Int64(T.min)
        let c = b % Int64(T.max)
        return T(c)
    }
}
private func random(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    for _ in 0..<length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

extension MutableCollection {
    mutating func shuffle() {
        if count < 2 { return }
        
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}
extension Collection {
    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
extension Dictionary {
    init(keys: [Key], values: [Value]) {
        self.init()
        for (key, value) in zip(keys, values) {
            self[key] = value
        }
    }
}

enum SampleEnum: AutoEqual {
    case A
    case B(Int)
    case C(Float)
    case D
    
    static func rand() -> SampleEnum {
        let a = arc4random() % 4
        let b: Int = random()
        
        switch a {
        case 0:
            return .A
        case 1:
            return .B(b)
        case 2:
            return .C(Float(b) / 10000.0)
        default:
            return .D
        }
    }
}
struct SampleValue: AutoEqual {
    var aa: NSNumber
    var bb: NSNumber
    var cc: NSString
    var dd: NSDate
    var ee: NSArray
    var ff: NSDictionary
    var gg: CountableClosedRange<UInt>
    var hh: CountableRange<UInt>
    var ii: Set<String>
    var jj: (Int, String)
    var kk: ((Date, Bool) -> Int)
    
    init() {
        let a: Int = random()
        let b: Int = random()
        aa = NSNumber(value: a)
        bb = NSNumber(value: b)
        cc = NSString(string: random(length: 100))
        dd = NSDate()
        ee = NSArray(array: [aa, bb, cc, dd].shuffled())
        ff = NSDictionary(
            dictionary: Dictionary(
                keys: [
                    random(length: 40),
                    random(length: 40),
                    random(length: 40),
                    random(length: 40),
                    random(length: 40)
                ],
                values: [aa, bb, cc, dd, ee].shuffled()
            )
        )
        gg = 0...(random())
        hh = 0..<(random() + 1)
        ii = Set(ff.allKeys as! [String])
        jj = (random(), random(length: 5))
        kk = { (Date, Bool) -> Int in
            return random()
        }
    }
}

class ParentType {
    var aaa: Int
    
    init() {
        aaa = random()
    }
}

struct StructType: AutoEqual {
    var a: Int
    var b: Int8
    var c: Int16
    var d: Int32
    var e: Int64
    var f: UInt
    var g: UInt8
    var h: UInt16
    var i: UInt32
    var j: UInt64
    var k: Float
    var l: Float80
    var n: Bool
    var m: Double
    var o: String
    var p: Character
    var q: [Any?]
    var r: [String: Any?]
    var s: SampleValue
    var t: Date
    var u: SampleEnum
    
    init() {
        a = random()
        b = random()
        c = random()
        d = random()
        e = random()
        f = random()
        g = random()
        h = random()
        i = random()
        j = random()
        k = Float(a) / 10000.0
        l = Float80(d) / 10000.0
        n = (e % 2 == 0 ? true : false)
        m = Double(e) / 10000.0
        o = random(length: 100)
        p = o.characters.first!
        q = [a, b, c, d, e, f, g, h, i, j, k, l, n, m, o, p].shuffled()
        r = Dictionary(
            keys: [
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40)
            ],
            values: [a, b, c, d, e, f, g, h, i, j, k, l, n, m, o, p, q].shuffled()
        )
        s = SampleValue()
        t = Date()
        u = SampleEnum.rand()
    }
}
class ClassType: ParentType, AutoEqual {
    var a: Int
    var b: Int8
    var c: Int16
    var d: Int32
    var e: Int64
    var f: UInt
    var g: UInt8
    var h: UInt16
    var i: UInt32
    var j: UInt64
    var k: Float
    var l: Float80
    var n: Bool
    var m: Double
    var o: String
    var p: Character
    var q: [Any?]
    var r: [String: Any?]
    var s: SampleValue
    var t: StructType
    var u: Date
    var v: SampleEnum
    
    override init() {
        a = random()
        b = random()
        c = random()
        d = random()
        e = random()
        f = random()
        g = random()
        h = random()
        i = random()
        j = random()
        k = Float(a) / 10000.0
        l = Float80(d) / 10000.0
        n = (e % 2 == 0 ? true : false)
        m = Double(e) / 10000.0
        o = random(length: 100)
        p = o.characters.first!
        q = [a, b, c, d, e, f, g, h, i, j, k, l, n, m, o, p].shuffled()
        r = Dictionary(
            keys: [
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40),
                random(length: 40)
            ],
            values: [a, b, c, d, e, f, g, h, i, j, k, l, n, m, o, p, q].shuffled()
        )
        s = SampleValue()
        t = StructType()
        u = Date()
        v = SampleEnum.rand()
        
        super.init()
    }
}

class AutoEqualTests: XCTestCase {
    
    func testAssertion() {
        let a = [ParentType()]
        let b = [ParentType()]
        
        /// assertionFailure() called!
        /// ParentType is not implemented AutoEqual.
        // XCTAssertNoThrow(a == b)
    }
    
    func testArray() {
        let a: [[Any?]]? = [[1, "A", 1.1, Date()]]
        let b: [[Any?]]? = [[1, nil, 3]]
        let c = a
        
        XCTAssertTrue(a != b)
        XCTAssertTrue(b != a)
        XCTAssertTrue(a == c)
        XCTAssertTrue(c == a)
        XCTAssertFalse(a == nil)
        XCTAssertFalse(nil == b)
        
        let d: [Any] = [1, "A", 1.1, Date()]
        let e: [Any] = [1, "A"]
        XCTAssertTrue(d != e)
        XCTAssertTrue(e != d)
    }
    
    func testArrayDictionary() {
        let a: [[String: Any?]]? = [[
            "test1": 1,
            "test2": "A"
        ]]
        let b: [[String: Any?]]? = [[
            "test1": nil
        ]]
        let c = a
        
        XCTAssertTrue(a != b)
        XCTAssertTrue(b != a)
        XCTAssertTrue(a == c)
        XCTAssertTrue(c == a)
        XCTAssertFalse(a == nil)
        XCTAssertFalse(nil == b)
        
        let d: [String: Any]? = [
            "K": 1,
            "A": Date()
        ]
        let e: [String: Any]? = [
            "A": "A"
        ]
        XCTAssertTrue(d != e)
        XCTAssertFalse(d == nil)
        XCTAssertFalse(nil == e)
    }
    
    func testDictionary() {
        let a = [
            "K": [
                "test1": 1,
                "test2": "A"
            ]
        ]
        let b = [
            "E": [
                "test1": 1
            ]
        ]
        let c = a
        
        XCTAssertTrue(a != b)
        XCTAssertTrue(b != a)
        XCTAssertTrue(a == c)
        XCTAssertTrue(c == a)
    }
    
    func testStruct() {
        let a = StructType()
        var b = StructType()
        XCTAssertEqual(a, a)
        XCTAssertEqual(b, b)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, a)
        
        let c = a
        XCTAssertEqual(a, c)
        XCTAssertEqual(c, a)
        
        var d = a
        d.s.aa = NSNumber(value: 1.1)
        d.r.removeValue(forKey: d.r.keys.first!)
        XCTAssertNotEqual(a, d)
        XCTAssertNotEqual(d, a)
        
        var e = a
        e.q.remove(at: 0)
        XCTAssertNotEqual(a, e)
        XCTAssertNotEqual(e, a)
        
        b.a = a.a
        b.b = a.b
        b.c = a.c
        b.d = a.d
        b.e = a.e
        b.f = a.f
        b.g = a.g
        b.h = a.h
        b.i = a.i
        b.j = a.j
        b.k = a.k
        b.l = a.l
        b.n = a.n
        b.m = a.m
        b.o = a.o
        b.p = a.p
        b.q = a.q
        b.r = a.r
        b.s = a.s
        b.t = a.t
        b.u = a.u
        XCTAssertEqual(a, b)
        XCTAssertEqual(b, a)
    }
    func testClass() {
        let a = ClassType()
        let b = ClassType()
        XCTAssertEqual(a, a)
        XCTAssertEqual(b, b)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, a)
        
        let c = a
        XCTAssertEqual(a, c)
        XCTAssertEqual(c, a)
        
        b.aaa = a.aaa
        b.a = a.a
        b.b = a.b
        b.c = a.c
        b.d = a.d
        b.e = a.e
        b.f = a.f
        b.g = a.g
        b.h = a.h
        b.i = a.i
        b.j = a.j
        b.k = a.k
        b.l = a.l
        b.n = a.n
        b.m = a.m
        b.o = a.o
        b.p = a.p
        b.q = a.q
        b.r = a.r
        b.s = a.s
        b.t = a.t
        b.u = a.u
        b.v = a.v
        XCTAssertEqual(a, b)
        XCTAssertEqual(b, a)
        
        b.q[1] = nil
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, a)
        
        b.q[0] = SampleEnum.A
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, a)
    }
    
}
