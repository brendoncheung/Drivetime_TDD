//
//  testJobRequestDataProvider.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 1/30/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

class testJobRequestDataProvider: XCTestCase {
    
    var sut: JobRequestDataProvider!
    var tableView: UITableView!
    var fakeUsername: String!
    var fakePassword: String!
    var fakeURL: URL!
    var mockClient: MockClient!
    
    var mockDelegate: MockJobRequestDelegate!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockClient = MockClient()
        
        fakeUsername = "fakeuser"
        fakePassword = "fakepassword"
        
        helper()
        
        mockDelegate = MockJobRequestDelegate()
        
        sut = JobRequestDataProvider(client: mockClient, delegate: mockDelegate)
        
        tableView = UITableView()
        tableView.dataSource = sut
        tableView.register(UINib(nibName: "JobRequestCell", bundle: nil), forCellReuseIdentifier: "JobRequestCell")
        
        fakeURL = URL(string: "https://www.mock.com")!
    }
    
    func helper() {
        
        mockClient.keychainItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: fakeUsername, accessGroup: KeychainConfiguration.accessGroup)
        
        mockClient.accountName = fakeUsername
        
        try! mockClient.keychainItem?.savePassword(fakePassword!)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        tableView = nil
        fakeURL = nil
    }
    
    func testNumberOfSection_ShouldEqualToOne() {
        XCTAssertEqual(tableView.numberOfSections, 1)
    }
    
// -> Testing load data function
    
    func testLoadData_UponSuccessful_shouldIncreaseJobRequestCountByTwo() {
        
        sut.loadData()
        XCTAssertEqual(sut.jobRequests.count, 2)
    }
    
    func testLoadData_UponSuccessful_ShouldCallDelegateMethod() {
        
        sut.loadData()
        
        XCTAssertTrue(mockDelegate.isCalled)
    }
}

extension testJobRequestDataProvider {
    
    class MockClient: APIClient, LoginSavable {
        
        var keychainItem: KeychainPasswordItem?
        var accountName: String?
        
        func loginUser(from url: URL, with username: String, and password: String, completionHandler: @escaping (DrivetimeUserProfile?, DrivetimeAPIError.LoginError?) -> Void) {
        }
        
        func fetchJobRequest(from url: URL, driverEmail: String, completionHandler: @escaping ([DrivetimeJob]?, DrivetimeAPIError.FetchJobRequestError?) -> Void) {
            
            let jobOne = DrivetimeJob(id: 123, requestID: "123", businessName: "first business name", businessEmail: "first business email", title: "first title", detail: "first detail", loadDescription: "first description", price: "first price", pickupAddress: "first pickup", dropOffAddress: "first dropoff", timestamp: "123")
            
            let jobTwo = DrivetimeJob(id: 123, requestID: "123", businessName: "second business name", businessEmail: "second business email", title: "second title", detail: "second detail", loadDescription: "second description", price: "second price", pickupAddress: "second pickup", dropOffAddress: "second dropoff", timestamp: "123")
            
            let jobs = [jobOne, jobTwo]
            
            completionHandler(jobs, nil)
            
        }
        
        func acceptJobRequest(from url: URL, with id: String, email: String, completionHandler: @escaping (DrivetimeAPIError.AcceptJobRequestError?) -> Void) {
            
        }
    }

    class MockJobRequestDelegate: JobRequestDelegate {
        
        var isCalled: Bool = false
        
        func onFetchingJobRequestComplete() {
            isCalled = true
        }
    }
}
