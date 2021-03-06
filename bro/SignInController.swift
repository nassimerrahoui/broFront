//
//  SignInController.swift
//  bro
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsernameTextField.layer.borderWidth = 1
        UsernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        UsernameTextField.layer.cornerRadius = 10
        PasswordTextField.layer.borderWidth = 1
        PasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        PasswordTextField.layer.cornerRadius = 10
        
        UsernameTextField.text = ""
        PasswordTextField.text = ""
        
        UsernameTextField.placeholder = "Email Address"
        PasswordTextField.placeholder = "Password"
    }
    
    @IBAction func connection(_ sender: Any) {
        let urlApi = userDefault.string(forKey: "urlApi")
        if let urlApi = urlApi{
            let apiRequest = ApiRequest.init(urlAPI: urlApi)
            if let email = UsernameTextField.text, let password = PasswordTextField.text {
                apiRequest.connection(email: email, password: password) { (token) -> (Void) in
                    if let token = token {
                        let defaults = UserDefaults.standard
                        defaults.set(token, forKey: "token")
                        
                        apiRequest.getUser(token: token){(userResponse) -> (Void)
                            in
                            if let userResponse = userResponse {
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: userResponse)
                                defaults.set(encodedData, forKey : "user")
                            }
                        }
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! UITabBarController
                        self.present(nextViewController, animated:true)
                    }
                }
            }
        }
    }
}


