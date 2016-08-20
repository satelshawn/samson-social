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
import KeychainSwift
//import SwiftKeychainWrapper
//import KeychainSwit

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //KeychainWrapper.stringForKey(KEY_UID)
        if let _ = keychain.get(KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: self)
        }
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
                if let user = user {
                    //let saveSuccessful: Bool = KeychainWrapper.setString(user.uid, forKey: KEY_UID)
                    //KeychainWrapper.setString(user.uid, forKey: KEY_UID)
                    let userData = ["provider" : credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
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
                    
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }

                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("Shawn: There has been an error creating the email account and authenticating on Firebase - \(error)")
                            
                        } else {
                            
                            print("Shawn: New account created. Successfully authenticated Firebase.")
                            
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData : Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let successful = keychain.set(id, forKey: KEY_UID)//KeychainWrapper.setString(id, forKey: KEY_UID)
        print("Shawn: The keychain addition was \(successful)")
        performSegue(withIdentifier: "goToFeed", sender: self)
    }
    

}

