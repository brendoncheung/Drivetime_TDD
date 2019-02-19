//
//  JobRequestDataProvider.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 1/30/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import Foundation
import UIKit

protocol JobRequestDelegate: class {
    func onFetchingJobRequestComplete()
}

class JobRequestDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let JOB_REQUEST_BASE_URL = "https://www.prodrivetime.com/api/driverApi/driverRequestLoad.php"
    
    let client: APIClient & LoginSavable
    weak var delegate: JobRequestDelegate?
    
    var jobRequests = [DrivetimeJob]() {
        didSet {
            delegate?.onFetchingJobRequestComplete()
        }
    }
    
    init(client: (APIClient & LoginSavable), delegate: JobRequestDelegate) {
        self.client = client
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobRequests.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobRequestCell", for: indexPath) as! JobRequestCell

        cell.businessName.text = jobRequests[indexPath.row].businessName
        cell.pickUpAddress.text = "Pickup Address: \(jobRequests[indexPath.row].pickupAddress)"
        cell.dropOffAddress.text = "Dropoff Address: \(jobRequests[indexPath.row].dropOffAddress)"
        cell.businessEmail.text = jobRequests[indexPath.row].businessEmail
        cell.timestamp.text = jobRequests[indexPath.row].timestamp
        
        return cell
    }
    
    func loadData() {
        
        let url = URL(string: JOB_REQUEST_BASE_URL)!
        
        client.fetchJobRequest(from: url, driverEmail: client.accountName!) { [weak self] (data, error) in

            guard let data = data else { return }
            
            self?.performUpdateOnMainThread {
                self?.jobRequests = data
            }
        }
    }
    
    func performUpdateOnMainThread(closure: @escaping () -> ()) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}






