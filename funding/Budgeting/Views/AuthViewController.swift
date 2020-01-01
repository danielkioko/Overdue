//
//  AuthenticateViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 12/31/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

class AuthenticateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.bool(forKey: "switchKeyName") == true){
            authenticateUser()
        }
        
    }
    
    func authenticateUser() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock Overdue"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.proceedToApp()
                    } else {
                        let alert = UIAlertController(title: "Authentication Failed", message: "Sorry, please try again", preferredStyle: .alert)
                        self.present(alert, animated: true)
                    }
                }
                
            }
            
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    func proceedToApp() {
       if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as? MainViewController {
           if let navigator = navigationController {
               navigator.pushViewController(viewController, animated: true)
           }
       }
    }
    
}
