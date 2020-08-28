//
//  ViewController.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/16/20.
// @author Parshant Juneja
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController {
    /* arrangedSubviews[0] is username textfield.
    arrangedSubviews[1] is password textfield.
    arrangedSubviews[2] is loginButton.
    arrangedSubviews[3] is the divider stackView.
    arrangedSubviews[4] is google sign in button. */
    @IBOutlet weak var loginStackView: UIStackView!
    var user: User?
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // The line below tries to sign you in google when open the app
        GIDSignIn.sharedInstance().signIn()
        for view in loginStackView.arrangedSubviews {
            if view.tag == 1 {
                view.layer.cornerRadius = 10
            } else {
                view.layer.cornerRadius = 5
            }
            view.layer.masksToBounds = true
        }
        addActionSelectorToLoginButton()
        signUpButton.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "loginToHome" {
                if let destination = segue.destination as? HomeViewController {
                    destination.user = self.user
                }
            } else if identifier == "loginToCreateNewAccount" {
                if let destination = segue.destination as? CreateNewAccountViewController {
                    
                }
            }
        }
    }
    
    func getEmail() -> String {
        if let emailTextField = loginStackView.arrangedSubviews[0] as? UITextField {
            if let text = emailTextField.text {
                return text
            } else {
                return ""
            }
        }
        return ""
    }
    
    func getPassword() -> String {
        if let passwordTextField = loginStackView.arrangedSubviews[1] as? UITextField {
            if let text = passwordTextField.text {
                return text
            } else {
                return ""
            }
        }
        return ""
    }
    
    func addActionSelectorToLoginButton() -> Void {
        if let loginButton = loginStackView.arrangedSubviews[2] as? UIButton {
            loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        }
    }
    
    @objc func loginButtonClicked() -> Void {
        let email = getEmail()
        let password = getPassword()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let error = error {
                print("\(error)")
            }
            else {
                let uid = authResult?.user.uid
                let user = NativeUser(email: email, password: password)

                strongSelf.user = user
                strongSelf.performSegue(withIdentifier: "loginToHome", sender: self)
            }
        }
    }
    
    @IBAction func createNewAccountTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginToCreateNewAccount", sender: self)
    }
}
extension ViewController: GIDSignInDelegate {
    /* Implementing the GIDSignInDelegate Protocol. */
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Sign in unsuccessful. Got \(error)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Unable to sign in and retrieve data. Got\(error)")
                return
            }
            guard let uid = authResult?.user.uid else { return }
            guard let email = authResult?.user.email else { return }
            guard let username = authResult?.user.displayName else { return }
            let googleUser = GoogleUser(email: email, username: username)
            
            self.user = googleUser
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    /* When the user disconnects save the data into the database. */
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
