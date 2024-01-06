//
//  Login_ViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/03/24.
//

import UIKit
import Firebase
import FirebaseAuth

class Login_ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var login_Exception: UILabel!
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 이미 로그인이 되어있는 경우 바로 캘린더로 넘어감
        if let user = Auth.auth().currentUser {
            DispatchQueue.main.async {
                self.dotToComma(eMail: user.email!)
                guard let goCal = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalenderViewController else {return}
                goCal.id = self.email
                goCal.modalPresentationStyle = .fullScreen
                self.present(goCal, animated: true, completion: nil)            }
        }
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        _ = sender.currentTitle
        
        Auth.auth().signIn(withEmail:  emailTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil {
                
                guard let goCal = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalenderViewController else {return}
                
                self.dotToComma(eMail: self.emailTextField.text!)
                goCal.id = self.email
                goCal.modalPresentationStyle = .fullScreen
                self.present(goCal, animated: true, completion: nil)
                
                print("login success")
                self.emailTextField.text = ""
                self.pwTextField.text = ""
                
                if self.login_Exception.isHidden == false {
                    self.login_Exception.isHidden = true
                }
            }
            
            else {
                self.login_Exception.isHidden = false
            }
        }
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        self.login_Exception.isHidden = true
    }
    
        
        public func dotToComma(eMail : String) {
            email = eMail.replacingOccurrences(of: ".", with: ",")
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
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
