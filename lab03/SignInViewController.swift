//
//  SignInViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 12/4/2022.
//

import UIKit

import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    weak var databaseController: DatabaseProtocol?

    
    
    
    override func viewDidLoad() {
        passwordTextField.isSecureTextEntry = true
        
        // initialise firebase
//        FirebaseApp.configure()
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func displayMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil ))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword(password: String) -> Bool {
        
        if password.isEmpty == false {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if let email = email, let password = password {
            if validateEmail(email: email) == true && validatePassword(password: password) == true {
                databaseController?.logInUser(email: email, password: password)
            }
            
            else {
                displayMessage(title: "", message: "")
            }
        }
        
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if let email = email, let password = password {
            if validateEmail(email: email) == true && validatePassword(password: password) {
                databaseController?.createUser(newEmail: email, newPassword: password)
            }
            
            else {
                displayMessage(title: "", message: "")
            }
        
        
        
    }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
