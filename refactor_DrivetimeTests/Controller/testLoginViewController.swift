//
//  testLoginViewController.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 1/31/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

class testLoginViewController: XCTestCase {
    
    //    Is the outlet hooked up to a view?
    //    Is the outlet connected to the action we want?
    //    Invoke the action directly, as if it had been triggered   by the outlet.
    
    var sut: LoginViewController!
    
    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = (storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController)
        
        _ = sut.view
        
        UIApplication.shared.keyWindow?.rootViewController = sut
    }
    
    override func tearDown() {sut = nil}
    
// -> TESTING INITIALIZATION
    
    func testApiClient_ShouldNotBeNil() {
        XCTAssertNotNil(sut.client)
    }
    
    func testIBOutlets_ShouldNotBeNil() {
        XCTAssertNotNil(sut.passwordTextField)
        XCTAssertNotNil(sut.userNameTextField)
        XCTAssertNotNil(sut.loginButton)
    }
    
    func testUserNameTextField_ShouldHaveContentTypeOfEmail() {
        XCTAssertEqual(sut.userNameTextField.textContentType, UITextContentType.emailAddress)
    }
    
    func testPasswordTextField_ShouldHaveContentTypeOfPassword() {
        XCTAssertTrue(sut.passwordTextField.isSecureTextEntry)
    }
    
    func testLoginButton_ShouldHaveATarget() {
        
        let actions = sut.loginButton.actions(forTarget: sut, forControlEvent: .touchUpInside)
        
        XCTAssertNotNil(actions)
    }

// -> TESTING CLASS HELPER METHODS
    
    func testIsUsernameAndPasswordIsFilled() {
        
        sut.userNameTextField.text = ""
        sut.passwordTextField.text = "something"
        
        XCTAssertEqual(sut.isUsernameAndPasswordIsFilled(), false)
        
        sut.userNameTextField.text = "something"
        sut.passwordTextField.text = ""
        
        XCTAssertEqual(sut.isUsernameAndPasswordIsFilled(), false)
    }
    
    func testHandleLoginErrorWithEmptyData() {
        
        let error_1 = DrivetimeAPIError.LoginError.EmptyData
        
        sut.handleLoginError(error: error_1)
        
        let alert_with_error_1 = sut.presentedViewController as! UIAlertController
        
        XCTAssertEqual(alert_with_error_1.title, "Backend Error: Request failed")
    }
    
    func testHandleLoginErrorWithCannotDecodeJsonError() {

        let error_2 = DrivetimeAPIError.LoginError.CannotDecodeJson
        
        sut.handleLoginError(error: error_2)
        
        let alert_with_error_2 = sut.presentedViewController as! UIAlertController
        
        XCTAssertEqual(alert_with_error_2.title, "Backend Error: Cannot Decode JSON")
    }
    
    func testMakeAlertDialogue_ShouldDisplayTheCorrectTitleAndDescription() {
        
        let alert = sut.makeAlertDialogue(with: "Test Title", description: "Test Description")
        
        XCTAssertEqual(alert.title, "Test Title")
        XCTAssertEqual(alert.message, "Test Description")
        
    }
    
    func testMakeAlertDialogue_ShouldHaveACancelButton() {
        
        let alert = sut.makeAlertDialogue(with: "Test Title", description: "Test Description")
        
        XCTAssertEqual(alert.actions.first?.style, UIAlertAction.Style.cancel)
    }
    
// -> TESTING SEGUES
    
    func testSegue_UponSuccessful_ShouldPerformSegueToMainTabBarVC() {

        sut.client = MockAPIClientWUserProfileReturned()

        sut.onLoginButtonTapped(sut.loginButton)

        XCTAssertTrue(sut.presentedViewController is MainTabBarController)
    }
    
    func testSegue_UponLoginSuccessful_ShouldInitializeMainTabBarVCWithUserProfile() {
        
        let mockClient = MockAPIClientWUserProfileReturned()
        
        sut.client = mockClient
        
        sut.onLoginButtonTapped(sut.loginButton)
        
        let mainTabBarVC = sut.presentedViewController as! MainTabBarController
        
        XCTAssertEqual(mainTabBarVC.userProfile!.name, mockClient.mockUserProfile?.name)
    }
    
    func testSegue_UponLoginSuccessful_ShouldInitializeMainTabBarVCWithClient() throws {
        
        sut.client = MockAPIClientWUserProfileReturned()
        
        sut.userNameTextField.text = "mockusername"
        sut.passwordTextField.text = "mockpassword"
        
        sut.onLoginButtonTapped(sut.loginButton)
        
        let mainTabBarVC = sut.presentedViewController as! MainTabBarController
        
        XCTAssertNotNil(mainTabBarVC.client)
    }
    
    func testSegue_UponLoginSuccessful_ShouldInitializeMainTabBarVCWithClientWithPasswordSaved() throws {
        
        sut.client = MockAPIClientWUserProfileReturned()
        
        sut.userNameTextField.text = "611thesolutions@gmail.com"
        sut.passwordTextField.text = "testpassword"
        
        sut.onLoginButtonTapped(sut.loginButton)
        
        let mainTabBarVC = sut.presentedViewController as! MainTabBarController
        
        let key = mainTabBarVC.client?.keychainItem
        
        XCTAssertEqual(try key?.readPassword(), "testpassword")
        XCTAssertEqual(sut.client.accountName, "611thesolutions@gmail.com")
    }
    
}
extension testLoginViewController {
    
    class MockAPIClientWithEmptyData: APIClient, LoginSavable {
        
        var keychainItem: KeychainPasswordItem?
        var accountName: String?
        
        func loginUser(from url: URL, with username: String, and password: String, completionHandler: @escaping (DrivetimeUserProfile?, DrivetimeAPIError.LoginError?) -> Void) {
            completionHandler(nil, .EmptyData)
            
        }
        
        func fetchJobRequest(from url: URL, driverEmail: String, completionHandler: @escaping ([DrivetimeJob]?, DrivetimeAPIError.FetchJobRequestError?) -> Void) {
            completionHandler(nil, .EmptyData)
            
        }
        
        func acceptJobRequest(from url: URL, with id: String, email: String, completionHandler: @escaping (DrivetimeAPIError.AcceptJobRequestError?) -> Void) {
            completionHandler(.EmptyData)
        }
    }
    
    class MockAPIClientWUserProfileReturned: APIClient, LoginSavable {
        
        var keychainItem: KeychainPasswordItem?
        var accountName: String?
        var mockUserProfile: DrivetimeUserProfile?
        
        func loginUser(from url: URL, with username: String, and password: String, completionHandler: @escaping (DrivetimeUserProfile?, DrivetimeAPIError.LoginError?) -> Void) {
            
            mockUserProfile = DrivetimeUserProfile(driverId: "Test ID", name: "Test name", email: "Test email", phoneNumber: "Test phone", city: "Test city", state: "Test state", experience: 12)
            
            completionHandler(mockUserProfile, nil)
            
            keychainItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
            
            accountName = username
            try? keychainItem?.savePassword(password)
            
        }
        
        func fetchJobRequest(from url: URL, driverEmail: String, completionHandler: @escaping ([DrivetimeJob]?, DrivetimeAPIError.FetchJobRequestError?) -> Void) {
            completionHandler(nil, .EmptyData)
            
        }
        
        func acceptJobRequest(from url: URL, with id: String, email: String, completionHandler: @escaping (DrivetimeAPIError.AcceptJobRequestError?) -> Void) {
            completionHandler(.EmptyData)
        }
    }
    
    
    
    
    
    
}
