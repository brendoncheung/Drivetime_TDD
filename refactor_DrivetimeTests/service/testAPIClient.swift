//
//  DrivetimeAPISession.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 1/23/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

// 1. The HttpClient should submit the request with the same
//    URL as the assigned one.

// 2. The HttpClient should submit the request.

class testAPIClient: XCTestCase {
    
    var sut: DrivetimeAPIClient!
    var mockSession: MockSessionWithNoDataReturns!
    var fakeURL: URL!
    
    let fakeUsername = "fakeUsername"
    let fakePassword = "fakePassword"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSession = MockSessionWithNoDataReturns()
        sut = DrivetimeAPIClient(session: mockSession)
        
        guard let url = URL(string: "https://mockurl.com") else { XCTFail(); return }
        
        fakeURL = url
    }
    
    override func tearDown() {
        mockSession = nil
        sut = nil
    }

    
    // MARK: Testing initialization
    
    func testCachingPolicy_ShouldFetchDataEveryTimeAndNotUseLocalCache() {
        
        let cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        XCTAssertEqual(sut.cachePolicy, cachePolicy)
    }
    
    func testJSON_ShouldHaveCannotDecodeJSONIfJSONIsInvalid() {
        sut.session = MockSessionWithBadDrivetimeJobRequests()

    }
    
    func testClient_ShouldConformToBothAPIClientAndLoginSavable() {
        
        XCTAssertTrue(sut! is APIClient)
        XCTAssertTrue(sut! is LoginSavable)
        
    }
    
    // MARK: Testing fetching job requests
    
    func testJobRequest_ShouldBeAPostRequest() {
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (data, error) in
        }
        XCTAssertEqual(mockSession.urlRequest?.httpMethod, "POST")
    }
    
    func testJobRequest_ShouldSubmitTheCorrectHttpBody() {
        
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (data, error) in
        }
        let expectedBody = "driverEmail=\(fakeUsername)".data(using: .utf8)
        XCTAssertEqual(mockSession.urlRequest?.httpBody, expectedBody)
    }
    
    func testJobRequest_ShouldSubmitTheSameURLToDataTask() {
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (data, error) in
        }
        
        XCTAssertEqual(mockSession.urlRequest?.url, fakeURL)
    }
    
    func testJobRequest_ShouldCallResumeFromDataTask() {
        
        let dataTask = MockDataTask()
        mockSession.nextDataTask = dataTask
        
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (data, error) in
        }
        
        XCTAssertTrue(dataTask.resumeIsCalled)
    }
    
    func testJobRequestJSON_ShouldBeSerializableAndNoError() {
        
        sut.session = MockSessionWithFakeDrivetimeJobRequests()
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (data, error) in
            
            let firstJob = data?.first
            XCTAssertNil(error)

            XCTAssertEqual(firstJob?.id, 12)
            XCTAssertEqual(firstJob?.requestID, "rqst5c4f799a174c98.40533087")
            XCTAssertEqual(firstJob?.businessName, "611 Solutions")
            XCTAssertEqual(firstJob?.businessEmail, "611thesolutions@gmail.com")
            XCTAssertEqual(firstJob?.title, "asdKJHlkjhlKJH")
            XCTAssertEqual(firstJob?.detail, "KJHLK")
            XCTAssertEqual(firstJob?.loadDescription, "LKJKLJHLKJH")
            XCTAssertEqual(firstJob?.price, "2000")
            XCTAssertEqual(firstJob?.pickupAddress, "KLJH")
            XCTAssertEqual(firstJob?.dropOffAddress, "KLJHLKJH")
            XCTAssertEqual(firstJob?.timestamp, "2019-01-28 21:52:26")
        }
    }
    
    func testJobRequest_ShouldReturnEmptyDataErrorIfDataIsEmpty() {
        
        sut.session = MockSessionWithNoDataReturns()
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (jobs, error) in
            XCTAssertEqual(error, .EmptyData)
        }
    }
    
    func testJobRequest_ShouldReturnCannotDecodeJsonIfInvalid() {
        sut.session = MockSessionWithBadDrivetimeJobRequests()
        sut.fetchJobRequest(from: fakeURL, driverEmail: fakeUsername) { (data, error) in
            XCTAssertEqual(error, .CannotDecodeJson)
        }
        
    }
    
    // MARK: Testing Accepting job requests
    
    func testAcceptJobRequest_ShouldSubmitTheSameURL() {

        sut.acceptJobRequest(from: fakeURL, with: fakeUsername, email: fakePassword) { error in
        }
        XCTAssertEqual(mockSession.urlRequest?.url, fakeURL)
    }
    
    func testAcceptJobRequest_ShouldBeAPostRequest() {
        
        sut.acceptJobRequest(from: fakeURL, with: fakeUsername, email: fakePassword) { (error) in
        }
        
        XCTAssertEqual(mockSession.urlRequest?.httpMethod, "POST")
    }
    
    // MARK: Testing the Login function
    
    func testLoginUser_ShouldSubmitTheSameURL() {
        
        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in
        }
        
        XCTAssertEqual(mockSession.urlRequest?.url, fakeURL)
    }
    
    func testLoginUser_ShouldBeAPostRequest() {
        
        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in
            
        }
        XCTAssertEqual(mockSession.lastRequestMethod, "POST")
    }
    
    func testLoginUser_ShouldReturnEmptyDataErrorIfDataIsEmpty() {
        
        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in
            XCTAssertEqual(error, .EmptyData)
        }
    }

    func testLoginUser_ShouldReturnCannotDecodeJsonIfInvalid() {
        
        sut.session = MockSessionWithBadUserProfile()
        
        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in
            XCTAssertEqual(error, .CannotDecodeJson)
        }
    }
    
    func testLoginUserJSON_ShouldBeSerializable() {
        
        sut.session = MockSessionWithFakeUserProfile()

        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in

            XCTAssertNil(error)

            XCTAssertEqual(data?.driverId, "df32734e39b5a8879adc")
            XCTAssertEqual(data?.name, "611 demo")
            XCTAssertEqual(data?.email, nil)
            XCTAssertEqual(data?.phoneNumber, "1234567890")
            XCTAssertEqual(data?.city, "Boothwyn")
            XCTAssertEqual(data?.state, "PA")
            XCTAssertEqual(data?.experience, 12)
        }
    }
    
    func testLoginUser_UponSuccessful_ShouldSaveUsername() {
        
        sut.session = MockSessionWithFakeUserProfile()
        
        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in
            
        }
        
        XCTAssertEqual(sut.accountName, fakeUsername)
    }
    
    func testLoginUser_UponSuccessful_ShouldUseAccountNameAndSavePassword() throws {
        
        sut.session = MockSessionWithFakeUserProfile()
        
        sut.loginUser(from: fakeURL, with: fakeUsername, and: fakePassword) { (data, error) in
            
        }
        
        XCTAssertEqual(try sut.keychainItem?.readPassword(), fakePassword)
        
    }

//===============================
}

extension testAPIClient {
    
    class MockSessionWithNoDataReturns: DrivetimeAPISession {
        
        var completionHandler: Handler?
        var urlRequest: URLRequest?
        var lastRequestMethod: String?
        var nextDataTask = MockDataTask()
        
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        
        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DrivetimeAPIDataTask {
            
            self.completionHandler = completionHandler
            self.urlRequest = request
            self.lastRequestMethod = request.httpMethod
            
            return nextDataTask
        }
    }
    
    class MockSessionWithFakeDrivetimeJobRequests: DrivetimeAPISession {
        
        var urlRequest: URLRequest?
        
        func dataTask(with request: URLRequest, completionHandler: @escaping DrivetimeAPISession.DataTaskResult) -> DrivetimeAPIDataTask {
            
            let json = """
                            [
                                {
                                    "id": 12,
                                    "request_id": "rqst5c4f799a174c98.40533087",
                                    "business_name": "611 Solutions",
                                    "business_email": "611thesolutions@gmail.com",
                                    "title": "asdKJHlkjhlKJH",
                                    "details": "KJHLK",
                                    "load_description": "LKJKLJHLKJH",
                                    "amount_offered": "2000",
                                    "pickup_address": "KLJH",
                                    "dropoff_address": "KLJHLKJH",
                                    "timestamp": "2019-01-28 21:52:26"
                                }
                            ]
                        """
            
            let data = json.data(using: .utf8)
            urlRequest = request
            completionHandler(data, nil, nil)
            return MockDataTask()
        }
    }
    
    class MockDataTask: DrivetimeAPIDataTask {
        
        private (set) var resumeIsCalled = false
        
        func resume() {
            resumeIsCalled = true
        }
    }
    
    class MockSessionWithFakeUserProfile: DrivetimeAPISession {
        
        var completionHandler: DrivetimeAPISession.DataTaskResult?
        var urlRequest: URLRequest?
        
        func dataTask(with request: URLRequest, completionHandler: @escaping DrivetimeAPISession.DataTaskResult) -> DrivetimeAPIDataTask {
            
            let json = """
                            {
                                "driver_id": "df32734e39b5a8879adc",
                                "name": "611 demo",
                                "email": null,
                                "phone": "1234567890",
                                "city": "Boothwyn",
                                "state": "PA",
                                "experience": 12
                            }
                        """
            
            let data = json.data(using: .utf8)
            
            self.completionHandler = completionHandler
            self.urlRequest = request
            
            completionHandler(data, nil, nil)
            
            return MockDataTask()
        }
        
    }
    
    class MockSessionWithBadDrivetimeJobRequests: DrivetimeAPISession {
        
        var urlRequest: URLRequest?
        
        func dataTask(with request: URLRequest, completionHandler: @escaping DrivetimeAPISession.DataTaskResult) -> DrivetimeAPIDataTask {
            
            let json = """
                            Mock[
                                {
                                    "id": 12,
                                    "request_id": "rqst5c4f799a174c98.40533087",
                                    "business_name": "611 Solutions",
                                    "business_email": "611thesolutions@gmail.com",
                                    "title": "asdKJHlkjhlKJH",
                                    "details": "KJHLK",
                                    "load_description": "LKJKLJHLKJH",
                                    "amount_offered": "2000",
                                    "pickup_address": "KLJH",
                                    "dropoff_address": "KLJHLKJH",
                                    "timestamp": "2019-01-28 21:52:26"
                                }
                            ]
                        """
            
            let data = json.data(using: .utf8)
            urlRequest = request
            completionHandler(data, nil, nil)
            return MockDataTask()
        }
    }
    
    class MockSessionWithBadUserProfile: DrivetimeAPISession {
        
        var completionHandler: DrivetimeAPISession.DataTaskResult?
        var urlRequest: URLRequest?
        
        func dataTask(with request: URLRequest, completionHandler: @escaping DrivetimeAPISession.DataTaskResult) -> DrivetimeAPIDataTask {
            
            let json = """
                            Mock{
                                "driver_id": "df32734e39b5a8879adc",
                                "name": "611 demo",
                                "email": null,
                                "phone": "1234567890",
                                "city": "Boothwyn",
                                "state": "PA",
                                "experience": 12
                            }
                        """
            
            let data = json.data(using: .utf8)
            
            self.completionHandler = completionHandler
            self.urlRequest = request
            
            completionHandler(data, nil, nil)
            
            return MockDataTask()
        }
        
    }
}

