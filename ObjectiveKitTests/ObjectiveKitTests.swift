//
//  ObjectiveKitTests.swift
//  ObjectiveKitTests
//
//  Created by Roy Marmelstein on 11/11/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
import MapKit
@testable import ObjectiveKit

@objc class Subview: UIView {

    dynamic func testSelector() {
        print("test selector")
    }

    dynamic func swizzledSelector(){
        print("swizzled selector")
    }

}

@objc class ObjectiveKitTests: XCTestCase {

    let closureName = "random"

    dynamic func testSelector() {
        print("test selector")
    }

    func testAddClosure() {
        let methodExpectation = expectation(description: "Method was called")
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addMethodToClass(closureName, implementation: {
            methodExpectation.fulfill()
        })
        let view = UIView()
        view.performMethod(closureName)
        waitForExpectations(timeout: 0.1, handler:nil)
    }

    func testAddSelector() {
        let view = UIView()
        XCTAssertFalse(view.responds(to: #selector(testSelector)))
        let objectiveView = ObjectiveClass<UIView>()
        objectiveView.addSelectorToClass(#selector(testSelector), from: self)
        XCTAssert(view.responds(to: #selector(testSelector)))
    }

    func testIntrospection() {
        let objectiveView = ObjectiveClass<MKMapView>()
        let selectors = objectiveView.allSelectors()
        XCTAssert(selectors.contains(NSSelectorFromString("layoutSubviews")))
        let protocols = objectiveView.allProtocols()
        XCTAssert(protocols.contains("MKAnnotationManagerDelegate"))
        let properties = objectiveView.allProperties()
        XCTAssert(properties.contains("mapRegion"))
    }


}