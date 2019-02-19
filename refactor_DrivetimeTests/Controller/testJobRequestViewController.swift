//
//  testJobRequestViewController.swift
//  refactor_DrivetimeTests
//
//  Created by Wing Sun Cheung on 2/15/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import XCTest
@testable import refactor_Drivetime

class testJobRequestViewController: XCTestCase {
    
    var sut: JobRequestViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "JobRequestViewController") as? JobRequestViewController
        sut.jobRequestTableView.delegate = MockDataProvider()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    

    
}




extension testJobRequestViewController {
    
    class MockDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        let data = [
            DrivetimeJob(id: 123, requestID: "123", businessName: "first business name", businessEmail: "first business email", title: "first title", detail: "first detail", loadDescription: "first description", price: "first price", pickupAddress: "first pickup", dropOffAddress: "first dropoff", timestamp: "123"),
        
            DrivetimeJob(id: 123, requestID: "123", businessName: "second business name", businessEmail: "second business email", title: "second title", detail: "second detail", loadDescription: "second description", price: "second price", pickupAddress: "second pickup", dropOffAddress: "second dropoff", timestamp: "123")
        ]
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

        
        
        
        
        
        
        
    }
    
    
    
    
}
