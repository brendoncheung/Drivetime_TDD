//
//  testDrivetimeJobs.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 1/23/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

class testDrivetimeJobs: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_ShouldIntializeAllProperties() {
        _ = DrivetimeJob(id: 123, requestID: "123", businessName: "Business name", businessEmail: "Business email", title: "First title", detail: "First description", loadDescription: "Load description", price: "1000", pickupAddress: "Pick up", dropOffAddress: "Drop off", timestamp: "123")
    }

}
