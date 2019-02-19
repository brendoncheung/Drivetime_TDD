//
//  MainTabBarController.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 2/11/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    var userProfile: DrivetimeUserProfile?
    var client: (APIClient & LoginSavable)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewControllers()
    }
    
    func initializeViewControllers() {
        
        // This is be replaced by using the UITabBarViewController delegate methods to work with storyboard

        guard let userProfile = userProfile, let client = client else {fatalError()}
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        
        userProfileVC.userProfile = userProfile
        userProfileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let jobRequestVC = storyboard.instantiateViewController(withIdentifier: "JobRequestViewController") as! JobRequestViewController
        
        jobRequestVC.client = client
        jobRequestVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        
        settingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        let userProfileNavController = makeNavigationController(root: userProfileVC)
        let jobRequestNavController = makeNavigationController(root: jobRequestVC)
        let seetingNavController = makeNavigationController(root: settingVC)

        self.viewControllers = [userProfileNavController, jobRequestNavController, seetingNavController]
    }
    
    func makeNavigationController(root: UIViewController) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: root)
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }

}


