
import UIKit
import GoogleSignIn
import FirebaseAuth



protocol SocialLoginDelegate: class {
    func onLoginSuccess(user: User, type: SocialLoginType)
    func onloginSuccess(result: Any, loginType: SocialLoginType)
    func errorInSocialLogin(error:String)
    func getWebServiceManager() -> WebServiceManager
}
extension SocialLoginDelegate {
    func onloginSuccess(result: Any, loginType: SocialLoginType) {}
}

enum SocialLoginType{
    case facebook
    case google
}

/**
File : SocialLoginManager

This File is the login interface for social login.

- Author:
Sarabjeet Singh

- Date:
17/01/20

- Version:
1.0
*/



class SocialLoginManager: NSObject{
 
    //MARK:- Variables
    weak var delegate : SocialLoginDelegate?
    private lazy var facebookLoginManger: FacebookLoginManager = {
        let facebookLoginManger = FacebookLoginManager()
        return facebookLoginManger
    }()
    private lazy var googleLoginManager: GoogleLoginManager = {
        let googleLoginManager = GoogleLoginManager()
        return googleLoginManager
    }()
    
    public override init() {
        super.init()
    }
    
    //MARK: Login
    func login(loginType: SocialLoginType, controller: UIViewController){
        switch loginType {
        case .facebook: //Facebook login
            facebookLogin(controller: controller)
        case .google: //Google login
            googleLogin(controller: controller)
        }
    }
    
    //MARK:- Private functions
    private func facebookLogin(controller: UIViewController){
        facebookLoginManger.delegate = delegate
        facebookLoginManger.loginWithFB(controller: controller, completion: {
            [weak self] (resultDict, token, error) in
            if let err = error {
                self?.delegate?.errorInSocialLogin(error: err.localizedDescription)
            }
            else {
                let user = User(fbUser: resultDict as Any)
                self?.delegate?.onLoginSuccess(user: user, type: .facebook)
            }
        })
    }
    
    private func googleLogin(controller: UIViewController){
        GIDSignIn.sharedInstance()?.signOut()
        googleLoginManager.googleLogin(controller: controller, completion: {
            [weak self] (user, error) in
            if let err = error {
                self?.delegate?.errorInSocialLogin(error: err.localizedDescription)
            }
            else if let _user = user {
                let user = User(googleUser: _user)
                self?.delegate?.onLoginSuccess(user: user, type: .google)
            }
        })
    }
}



