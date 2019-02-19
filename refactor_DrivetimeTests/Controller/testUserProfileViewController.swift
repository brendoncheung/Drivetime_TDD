//
//  testUserProfileViewController.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 2/12/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

class testUserProfileViewController: XCTestCase {
    
    var sut: UserProfileViewController?
    var mockProfile: DrivetimeUserProfile?

    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
        
        mockProfile = DrivetimeUserProfile(driverId: "Test ID", name: "Test name", email: "Test email", phoneNumber: "Test phone", city: "Test city", state: "Test state", experience: 12)
        
        sut?.userProfile = mockProfile
        sut?.loadViewIfNeeded()
        _ = sut?.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

// -> Initialization
    
    func testInitialization_AllIBOutletsShouldBeConnected() {
        
        XCTAssertNotNil(sut?.usernameLabel)
        XCTAssertNotNil(sut?.userEmail)
        XCTAssertNotNil(sut?.userDriverIDLabel)
        XCTAssertNotNil(sut?.userPhoneNumberLabel)
        XCTAssertNotNil(sut?.userCityLabel)
        XCTAssertNotNil(sut?.userStateLabel)
        XCTAssertNotNil(sut?.userExperienceLabel)
    }
    
    func testUserProfile_UponInitialization_ShouldPopulateWithUserProfileInformation() {
        
        XCTAssertEqual(sut?.usernameLabel.text, "Name: \(mockProfile?.name ?? "Not provided")")
        XCTAssertEqual(sut?.userEmail.text, "Email: \(mockProfile?.email ?? "Not provided")")
        XCTAssertEqual(sut?.userDriverIDLabel.text, "Driver ID: \(mockProfile?.driverId ?? "Not provided")")
        XCTAssertEqual(sut?.userPhoneNumberLabel.text, "Phone: \(mockProfile?.phoneNumber ?? "Not provided")")
        XCTAssertEqual(sut?.userCityLabel.text, "City: \(mockProfile?.city ?? "Not provided")")
        XCTAssertEqual(sut?.userStateLabel.text,  "State: \(mockProfile?.state ?? "Not provided")")
        XCTAssertEqual(sut?.userExperienceLabel.text, "Experience: \(mockProfile?.experience?.description ?? "Not provided")")
        
    }
}
