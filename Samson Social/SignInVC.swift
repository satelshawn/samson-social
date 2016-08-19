//
//  SignInVC.swift
//  Samson Social
//
//  Created by Shawn Truesdell on 18/08/2016.
//  Copyright © 2016 Satel Develops. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Shawn: Unable to authenticate with Firebase - \(error).")
            } else {
                print("Shawn: Successfully authenticated with Firebase.")
            }
        })
    }
    
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Shawn: Unable to authenticate with Facebook - \(error).")
            } else if result?.isCancelled == true {
                print("Shawn: User cancelled Facebook authentication.")
            } else {
                print("Shawn: successfully Authenticated with Facebook.")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    
                    print("Shawn: Email user Authenticated with Firebase.")
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("Shawn: There has been an error creating the email account and authenticating on Firebase - \(error)")
                            
                        } else {
                            
                            print("Shawn: New account created. Successfully authenticated Firebase.")
                            
                        }
                    })
                }
            })
        }
    }
    
    

}

