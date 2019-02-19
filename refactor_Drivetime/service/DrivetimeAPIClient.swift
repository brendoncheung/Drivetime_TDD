//
//  JobRequestManager.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 1/23/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import Foundation

protocol DrivetimeAPISession {
    
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> DrivetimeAPIDataTask
}

protocol DrivetimeAPIDataTask {
    func resume()
}

enum DrivetimeAPIError: Error {

    enum LoginError {
        case EmptyData
        case CannotDecodeJson
    }
    
    enum FetchJobRequestError {
        case EmptyData
        case CannotDecodeJson
    }
    
    enum AcceptJobRequestError {
        case EmptyData
    }
}

protocol LoginSavable {
    var keychainItem: KeychainPasswordItem? {get set}
    var accountName: String? {get set}
}

protocol APIClient {
    
    func fetchJobRequest(from url: URL, driverEmail: String, completionHandler: @escaping ([DrivetimeJob]?, DrivetimeAPIError.FetchJobRequestError?) -> Void)
    
    func acceptJobRequest(from url: URL, with id: String, email: String, completionHandler: @escaping (DrivetimeAPIError.AcceptJobRequestError?) -> Void)
    
    func loginUser(from url: URL, with username: String, and password: String, completionHandler: @escaping (DrivetimeUserProfile?, DrivetimeAPIError.LoginError?) -> Void)
}

class DrivetimeAPIClient: APIClient, LoginSavable {
    
    var keychainItem: KeychainPasswordItem?
    var accountName: String?

    var session: DrivetimeAPISession
    let cachePolicy: URLRequest.CachePolicy

    init(session: DrivetimeAPISession = URLSession.shared, cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData) {
        self.session = session
        self.cachePolicy = cachePolicy
    }
    
    func fetchJobRequest(from url: URL, driverEmail: String, completionHandler: @escaping ([DrivetimeJob]?, DrivetimeAPIError.FetchJobRequestError?) -> Void) {
        
        var request = URLRequest(url: url)
        request.cachePolicy = cachePolicy
        request.httpMethod = "POST"
        request.httpBody = "driverEmail=\(driverEmail)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, .EmptyData)
                return }
            
            do {
                let jobs = try JSONDecoder().decode([DrivetimeJob].self, from: data)
                
                completionHandler(jobs, nil)
                
            } catch {
                completionHandler(nil, .CannotDecodeJson)
            }
        }
        task.resume()
    }
    
    func acceptJobRequest(from url: URL, with id: String, email: String, completionHandler: @escaping (DrivetimeAPIError.AcceptJobRequestError?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = cachePolicy

        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                completionHandler(.EmptyData)
                return
            }
            
            // TODO: Ask Chunk what is the return structure for accepting job request
            
            completionHandler(nil)
        }
        task.resume()
    }
    
    func loginUser(from url: URL, with username: String, and password: String, completionHandler: @escaping (DrivetimeUserProfile?, DrivetimeAPIError.LoginError?) -> Void) {
        
        let request = makeLoginRequest(url: url, with: username, password: password)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, .EmptyData)
                return
            }
            
            do {
                let userProfile = try JSONDecoder().decode(DrivetimeUserProfile.self, from: data)
                completionHandler(userProfile, nil)
                self.accountName = username
                self.keychainItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
                try self.keychainItem?.savePassword(password)
                
            } catch {
                completionHandler(nil, .CannotDecodeJson)
            }
        }
        task.resume()
    }
    
    func makeLoginRequest(url: URL, with username: String, password: String) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "email=\(username)&password=\(password)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

extension URLSession: DrivetimeAPISession {
    func dataTask(with request: URLRequest, completionHandler: @escaping DrivetimeAPISession.DataTaskResult) -> DrivetimeAPIDataTask {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: DrivetimeAPIDataTask{}



















