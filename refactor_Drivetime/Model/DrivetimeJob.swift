//
//  DrivetimeJob.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 1/23/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import Foundation

struct DrivetimeJob: Codable {
    
    let id: Int
    let requestID: String
    let businessName: String
    let businessEmail: String
    let title: String
    let detail: String
    let loadDescription: String
    let price: String
    let pickupAddress: String
    let dropOffAddress: String
    let timestamp: String
    
    init(id: Int, requestID: String, businessName: String, businessEmail: String, title: String, detail: String, loadDescription: String, price: String, pickupAddress: String, dropOffAddress: String, timestamp: String) {
        
        self.id = id
        self.requestID = requestID
        self.businessName = businessName
        self.businessEmail = businessEmail
        self.title = title
        self.detail = detail
        self.loadDescription = loadDescription
        self.price = price
        self.pickupAddress = pickupAddress
        self.dropOffAddress = dropOffAddress
        self.timestamp = timestamp
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case requestID = "request_id"
        case businessName = "business_name"
        case businessEmail = "business_email"
        case title = "title"
        case detail = "details"
        case loadDescription = "load_description"
        case price = "amount_offered"
        case pickupAddress = "pickup_address"
        case dropOffAddress = "dropoff_address"
        case timestamp = "timestamp"
    }
    

    
}

