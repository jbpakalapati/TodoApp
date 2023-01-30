//
//  RegisterViewController.swift
//  Todo App
//
//  Created by MacBook  on 1/27/23.
//

import UIKit
import ValidationTextField
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: ValidationTextField!
    
    @IBOutlet weak var passwordTF: ValidationTextField!
    
    @IBOutlet weak var rePassworrdTF: ValidationTextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setuptextfields()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if emailTF.isValid && rePassworrdTF.isValid {
            if let em = emailTF.text, let pw = rePassworrdTF.text{
                self.signUpUser(email: em, pwd: pw)
            } else{
                alertCreate(title: "Signup ", message: "Enter the valid details")
            }
            
        } else{
            alertCreate(title: "Signup ", message: "Enter the valid details")
        }
    }
    
    func setuptextfields() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        emailTF.placeholder = ""
        emailTF.titleText = "Enter your email ID"
        emailTF.errorMessage = "Enter valid email address"
        emailTF.validCondition = { $0.count > 5 && $0.contains("@") && $0.contains(".")}
        passwordTF.placeholder = ""
        passwordTF.titleText = "Enter the password"
        passwordTF.validCondition = {$0.count > 6}
        rePassworrdTF.placeholder = ""
        rePassworrdTF.titleText = "Re enter the password"
        rePassworrdTF.errorMessage = "Password is not matching"
        rePassworrdTF.validCondition = {
            guard let password = self.passwordTF.text else {
              return false
            }
            return $0 == password
          }
        
    }
    
    func signUpUser(email: String, pwd: String){
        Auth.auth().createUser(withEmail: email, password: pwd) { authResult, error in
          // ...
            if let er = error {
                self.alertCreate(title: "SignUp Error", message: "Not able to sign up user : \(er.localizedDescription)")
            } else{
                DispatchQueue.main.async {
                    //self.alertCreate(title: "SignUp Successfull", message: "You can add to do items")
                    self.performSegue(withIdentifier: Support.signUpSegue, sender: self)
                }
                
            }
        }
    }
    
    
    func alertCreate(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}
