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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Shawn: Unable to authenticate with Firebase - \(error).")
            } else {
                print("Shawn: Successfully authenticated with Firebase.")
            }
        })
    }

}

