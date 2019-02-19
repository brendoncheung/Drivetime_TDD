//
//  testMainTabBarViewController.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 2/12/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

class testMainTabBarViewController: XCTestCase {
    
    var sut: MainTabBarController?
    var mockProfile: DrivetimeUserProfile?

    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
        
        mockProfile = DrivetimeUserProfile(driverId: "Test ID", name: "Test name", email: "Test email", phoneNumber: "Test phone", city: "Test city", state: "Test state", experience: 12)
        
        sut?.userProfile = mockProfile
        sut?.client = DrivetimeAPIClient()
        sut?.userProfile = mockProfile
        
        // This function triggers viewDidLoad
        sut?.loadViewIfNeeded()
        
    }

    override func tearDown() {sut = nil}

// -> Test MainTabBarVC should have three controller
    
    func testInitialization_ShouldHaveThreeControllers() {
        XCTAssertEqual(sut?.viewControllers?.count, 3)
    }
    
// -> Test MainTabBarVC should initialize userprofileVC with userProfile
    func testUserProfileVC_UponInitialization_ShouldHaveUserProfile() {
        
        let userprofileNavController = sut?.viewControllers![0] as! UINavigationController
        
        let userProfileVC = userprofileNavController.viewControllers.first as! UserProfileViewController
        
        XCTAssertNotNil(userProfileVC.userProfile)
    }
    
    func testJobRequestVC_UponInitialization_ShouldHaveClient() {
        
        let jobRequestNavController = sut?.viewControllers![0] as! UINavigationController
        
        let jobRequestVC = jobRequestNavController.viewControllers.first as! UserProfileViewController
        
        XCTAssertNotNil(jobRequestVC.userProfile)
        
    }
    
    func testMakeNavigationController() {
        
        let vc = UIViewController()
        
        let navController = sut?.makeNavigationController(root: vc)
        
        XCTAssertTrue(navController?.viewControllers.first === vc)
        
    }
}
