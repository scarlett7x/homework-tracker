//
//  CreateNewAccountViewController.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/23/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit
import Firebase

class CreateNewAccountViewController: UIViewController {
    
    @IBOutlet weak var createAccountStackView: UIStackView!
    var user: User?
    
    func getEmail() -> String {
        if let emailTextField = createAccountStackView.arrangedSubviews[0] as? UITextField {
            if let email = emailTextField.text {
                return email
            }
            return ""
        }
        return ""
    }
    
    func getPassword() -> String {
        if let passwordTextField = createAccountStackView.arrangedSubviews[1] as? UITextField {
            if let password = passwordTextField.text {
                return password
            }
            return ""
        }
        return ""
    }
    
    @objc func createNewAccount() -> Void {
        let email = getEmail()
        let password = getPassword()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print("\(err)")
            }
            let nativeUser = NativeUser(email: email, password: password)
            self.user = nativeUser
            self.performSegue(withIdentifier: "createNewAccountToHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign Up"
        guard let createNewAccountButton = createAccountStackView.arrangedSubviews[2] as? UIButton else { return }
        createNewAccountButton.layer.cornerRadius = 10
        createNewAccountButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "createNewAccountToHome" {
                if let destination = segue.destination as? HomeViewController {
                    destination.user = self.user
                }
            }
        }
    }

}
