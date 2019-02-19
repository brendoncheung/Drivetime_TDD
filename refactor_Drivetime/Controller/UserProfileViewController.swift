//
//  UserProfileViewController.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 2/11/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var userProfile: DrivetimeUserProfile?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userDriverIDLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userStateLabel: UILabel!
    @IBOutlet weak var userExperienceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserProfile()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Driver Info"
    }
    
    func initializeUserProfile() {
        usernameLabel.text = "Name: \(userProfile?.name ?? "Not provided")"
        userEmail.text = "Email: \(userProfile?.email ?? "Not provided")"
        userDriverIDLabel.text = "Driver ID: \(userProfile?.driverId ?? "Not provided")"
        userPhoneNumberLabel.text = "Phone: \(userProfile?.phoneNumber ?? "Not provided")"
        userCityLabel.text = "City: \(userProfile?.city ?? "Not provided")"
        userStateLabel.text = "State: \(userProfile?.state ?? "Not provided")"
        userExperienceLabel.text = "Experience: \(userProfile?.experience?.description ?? "Not provided")"
    }

}












