//
//  EQTests.swift
//  EQTests
//
//  Created by Kenneth Cluff on 2/12/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import XCTest
@testable import EarthQuake

class EQTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingMajor() {
        // This is an example of a performance test case.
        let expectation = self.expectation(description: "Major query")
        let significantString = EQConstants.API.last30_4PlusURI
        RESTEngine.fetchSignificantData(uri: significantString) { (results, error) in
            if let _ = error {
                XCTAssertTrue(false, "There should be no errors with this query when there's a network connection")
            } else if let results = results {
                XCTAssertTrue(results.count > 0, "There's at least one result with this query")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetching30Day() {
        // This is an example of a performance test case.
        let expectation = self.expectation(description: "30 significant query")
        let significantString = EQConstants.API.last30DaysURI
        RESTEngine.fetchSignificantData(uri: significantString) { (results, error) in
            if let _ = error {
                XCTAssertTrue(false, "There should be no errors with this query when there's a network connection")
            } else if let results = results {
                XCTAssertTrue(results.count > 0, "There's at least one result with this query")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testBadQuery() {
        // This is an example of a performance test case.
        let expectation = self.expectation(description: "Bad query")
        let significantString = "http://www.apple.com"
        RESTEngine.fetchSignificantData(uri: significantString) { (results, error) in
            if let _ = error {
                XCTAssertTrue(true, "There should bean error with this query when there's a network connection")
            } else if let results = results {
                XCTAssertTrue(results.count > 0, "This shouldn't work")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
