//
//  ViewController.swift
//  Todo App
//
//  Created by MacBook  on 1/26/23.
//

import UIKit
import IntroScreen
import ValidationTextField
import FirebaseAuth
import ALLoadingView

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: ValidationTextField!
    @IBOutlet weak var passwordTextField: ValidationTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //var support = Support()
    let dataSource = MyIntroDataSource()
    var into = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "AccentColor")
        
        if (!UserDefaults.standard.bool(forKey: "Key")) {
            let viewController = IntroViewController(dataSource: dataSource)
            UserDefaults.standard.set(true, forKey: "Key")
            navigationController?.present(viewController, animated: true)
        } else{
           
        }
        
        setupTextValidation()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailTextField.isValid && passwordTextField.isValid{
            print("email valid")
            if let em = emailTextField.text, let pw = passwordTextField.text{
                loginUser(email: em, pwd: pw)
            }else {
                alertCreate(title: "Login Error", message: "Please enterr valid credentails")
            }
            
        }else{
            print("Enter valid email & password")
            alertCreate(title: "Login Error", message: "Please enterr valid credentails")
            
        }
    }
    
    func setupTextValidation(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        
        emailTextField.placeholder = ""
        emailTextField.titleText = "Enter your email ID"
        emailTextField.validCondition = {$0.count > 5 && $0.contains("@") && $0.contains(".")}
        passwordTextField.placeholder = ""
        passwordTextField.titleText = "Enter your password"
        passwordTextField.validCondition = {$0.count > 6}
    }
    
    func loginUser(email:String, pwd: String){
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .windowed)
        
        Auth.auth().signIn(withEmail: email, password: pwd) { [weak self] authResult, error in
          //guard let strongSelf = self else { return }
          // ...
            if let er = error{
                
                ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
                self?.alertCreate(title: "Login Error", message: "Unable to Login User : \(er.localizedDescription)")
            }else{
                print("user is : \(authResult?.user.email ?? "value")")
              
                ALLoadingView.manager.hideLoadingView(withDelay: 2.0)
                self?.performSegue(withIdentifier: Support.loginSegue, sender: self)
            }
        }
    }
    
    func alertCreate(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    

}

extension ViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)

    }
}

