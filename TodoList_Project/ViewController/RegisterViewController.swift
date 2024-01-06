//
//  RegisterViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/03/24.
//

// UI 부분
//



import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var email_Exception: UILabel!
    
    @IBOutlet weak var pw_Exception: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet var pwTextField: UITextField!
    
    @IBOutlet weak var overlapEmail: UILabel!
    
    //DB에 데이터를 넣을때 사용하는 변수
    var ref : DatabaseReference!
    
    let partList = [""]
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // 아이디 중복확인 검사 함수
    @IBAction func overlapButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            print("Please enter a valid email.")
            return
        }
        Auth.auth().fetchSignInMethods(forEmail: email) { (providers, error) in
            
            self.overlapEmail.isHidden = true
            // 에러
            if let error = error {
                self.overlapEmail.text = "올바른 이메일 형식을 입력하세요."
                self.overlapEmail.isHidden = false
            }
            
            // 이메일 형식 유효성 검사
            if !self.isValidEmail(email) {
                    //print("Please enter a valid email.")
                self.overlapEmail.text = "올바른 이메일 형식을 입력하세요."
                self.overlapEmail.isHidden = false
                    return
            }
            // 중복된 이메일 입력시
            if let providers = providers, providers.count > 0 {
                // 해당 이메일 주소로 이미 등록된 계정이 있음
                self.overlapEmail.text = "이미 가입된 이메일입니다."
                self.overlapEmail.isHidden = false
            }else {
                self.count = 1
                // 해당 이메일 주소로 등록된 계정이 없음
                self.overlapEmail.text = "사용가능한 이메일입니다."
                self.overlapEmail.isHidden = false
            }
        }

        
        
    }
    
    public func dotToComma(eMail : String) -> String {
        return eMail.replacingOccurrences(of: ".", with: ",")
    }
    
    func createPoint(){ //pointDB 생성
        let email = dotToComma(eMail: emailTextField.text!)
        self.ref = Database.database().reference()
        let pointRef = self.ref.child("\(email)/point")
        //테스트용으로 포인트설정 *0으로 다시 바꿀것*
        pointRef.setValue("500")
        
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        if self.count == 0{
            overlapEmail.isHidden = false
            overlapEmail.text = "중복확인 검사를 진행하세요."
            return
        }
        
        if email_Exception.isHidden == false{
            email_Exception.isHidden = true
        }
        if email_Exception.isHidden == false {
            email_Exception.isHidden = true
        }
        
        // emailTextField가 nil이거나 비어있는 경우 유효성 검사
        guard let email = emailTextField.text, !email.isEmpty else {
            //print("Please enter a valid email.")
            if email_Exception.isHidden == true{
                email_Exception.isHidden = false
            }
            return
        }
        
        // email 올바른 형식으로 작성되었는지 유효성 검사
        if !isValidEmail(email) {
                //print("Please enter a valid email.")
                if email_Exception.isHidden == true {
                    email_Exception.text = "올바른 이메일 형식을 입력하세요."
                    email_Exception.isHidden = false
                }
                return
            }
        
        // password가 nil이거나 6자리 미만일 경우 유효성 검사
        guard let password = pwTextField.text, password.count >= 6 else {
            //print("Password should be at least 6 characters.")
            if pw_Exception.isHidden == true{
                pw_Exception.isHidden = false
            }
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                self.createPoint()
                //print("Register success.")
                
                if self.email_Exception.isHidden == false{
                    self.email_Exception.isHidden = true
                }
                if self.pw_Exception.isHidden == false{
                    self.pw_Exception.isHidden = true
                }
                self.presentingViewController?.dismiss(animated: true)
                
            } else {
                //print("Register failed: \(error?.localizedDescription ?? "Unknown error")")
                self.email_Exception.text = "이미 존재하는 이메일 입니다."
                self.email_Exception.isHidden = false
            }
        }
    }

    
    // 이메일 유효성 검사
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
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
