//
//  ViewController.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 1/23/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let BASE_URL = "https://www.prodrivetime.com/api/mobileApi/mobileDriverLogin"
    
    lazy var client: (APIClient & LoginSavable) = {
        return DrivetimeAPIClient()
    }()
    
    var userProfile: DrivetimeUserProfile?
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.layer.cornerRadius = userNameTextField.frame.height / 3
            userNameTextField.layer.borderWidth = 3
            userNameTextField.layer.borderColor = UIColor(red: 99/255, green: 110/255, blue: 114/255, alpha: 1).cgColor
            userNameTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = loginButton.frame.height / 3
            loginButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 3
            passwordTextField.layer.borderWidth = 3
            passwordTextField.layer.borderColor = UIColor(red: 99/255, green: 110/255, blue: 114/255, alpha: 1).cgColor
            passwordTextField.layer.masksToBounds = true
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        
        let url = URL(string: BASE_URL)!
        
        if !isUsernameAndPasswordIsFilled() {
            let alert = makeAlertDialogue(with: "Incomplete Information", description: "Please make you enter both username and password")
            present(alert, animated: true, completion: nil)
            return
        }
        
        client.loginUser(from: url, with: userNameTextField.text!, and: passwordTextField.text!) { [weak self] (userProfile, error)  in
            
            self?.performUIUpdate {
                guard error == nil else {
                    self?.handleLoginError(error: error)
                    return
                }
                self?.userProfile = userProfile
                self?.performSegue(withIdentifier: "mainTabBarController", sender: nil)
                self?.client.keychainItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: (self?.userNameTextField.text!)!, accessGroup: KeychainConfiguration.accessGroup)
                self?.client.accountName = self?.userNameTextField.text
            }
        }
    }
    
    func performUIUpdate(using closure: @escaping () -> Void) {
        
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func makeAlertDialogue(with title: String, description: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        
        return alert
    }
    
    func handleLoginError(error: DrivetimeAPIError.LoginError?) {
        
        let title: String
        let description: String
        
        if let error = error {
            switch error {
                
            case .CannotDecodeJson:
                title = "Backend Error: Cannot Decode JSON"
                description = "Please contact technical support"
                
            case .EmptyData:
                title = "Backend Error: Request failed"
                description = "Please contact technical support"
            }
            
            let alert = self.makeAlertDialogue(with: title, description: description)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isUsernameAndPasswordIsFilled() -> Bool {
        
        var bool = true
        
        if userNameTextField.text == "" || passwordTextField.text == "" {
            bool = false
        }
        
        return bool
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MainTabBarController {
            destinationVC.userProfile = userProfile
            destinationVC.client = client
        }
    }
    
    
}













