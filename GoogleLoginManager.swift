

import Foundation
import FirebaseAuth
import GoogleSignIn

/**
File : GoogleLoginManager

This file is use for google login under social login module.

- Author:
Sarabjeet Singh

- Date:
17/01/20

- Version:
1.0
*/


class GoogleLoginManager : NSObject,GIDSignInUIDelegate,GIDSignInDelegate{
 
    typealias googleLoginResponse = (GIDGoogleUser?, Error?) -> ()
    private var responseCallback: googleLoginResponse?
    
    public override init() {
        super.init()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    func googleLogin(controller:UIViewController, completion: @escaping googleLoginResponse) {
        responseCallback = completion
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            Logger.log(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                Logger.log(error)
                self.responseCallback?(nil, error)
                return
            } else if let user = user {
                // Perform any operations on signed in user here.
                Logger.log("Success Google login")
                self.responseCallback?(user, nil)
            }
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

