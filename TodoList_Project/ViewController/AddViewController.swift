//
//  ViewController2.swift
//  table&present
//
//  Created by 차경태 on 2023/02/07.
//

import UIKit
import Firebase

//할일 등록
class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var color: UIButton!
    
    @IBOutlet weak var inputTitle: UITextField!
    
    @IBOutlet weak var labelSelectedDate: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var titleException: UILabel!
    
    var COLOR = UIColor(named: "Color")
    var defaultColor = UIColor(named: "Basic")
    var string : String?
    var currentDate = ""
    var selectedTime = ""
    var notification = ""
    var check = "black"
    var searchDB = [String]()
    
    var ref : DatabaseReference!
    
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
    let numberLabels: [UILabel] = [UILabel(), UILabel(), UILabel()]
    
    private lazy var menuItems: [UIAction] = {
                return [
                    UIAction(
                        title: "하루 전",
                        handler: { _ in
                            self.notification = "86400"
                        }),
                    UIAction(
                        title: "30분 전",
                        handler: { _ in
                            self.notification = "1800"
                        }),
                    UIAction(
                        title: "5분 전",
                        handler: { _ in
                            self.notification = "300"
                        }),
                    UIAction(
                        title: "이벤트 당시",
                        handler: { _ in
                            self.notification = "0"
                        }),
                    UIAction(
                        title: "없음",
                        handler: { _ in
                            self.notification = "no"
                        })
                ]
            }()
            
            private lazy var menu: UIMenu = {
                return UIMenu(title: "", options: [], children: menuItems)
            }()
    
    
    @IBOutlet weak var notificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        labelSelectedDate.text = currentDate
        color.layer.cornerRadius = 6
        color.backgroundColor = defaultColor
        defaultMenu()
        notificationButton.menu = menu
        notificationButton.showsMenuAsPrimaryAction = true
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
  
        let time = Int(dateFormatter.string(from: Date()))
        if (time! >= 30) {
            dateFormatter.dateFormat = "HH:30"
            selectedTime = dateFormatter.string(from: Date())
        }
        else {
            dateFormatter.dateFormat = "HH:00"
            selectedTime = dateFormatter.string(from: Date())
        }
        
        inputTitle.delegate = self
        view.addSubview(inputTitle)
        
        let customColor = UIColor(red: 207/255, green: 210/255, blue: 215/255, alpha: 1.0)

        customView.backgroundColor = customColor
        customView.isUserInteractionEnabled = true // 터치 인터랙션을 활성화합니다.
        labelSet()
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        customView.addGestureRecognizer(tapGesture) // 커스텀 뷰에 탭 제스처를 추가합니다.
        
    }
    
    func labelSet(){ // 키패드 상단에 Label 띄우기
        let preVC = self.presentingViewController
        guard let vc = preVC as? TableViewController else { return }
        
        let ref8 = Database.database().reference(withPath:"\(vc.id)/recentSearch")
        ref8.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let title = snapshot.value as? String {
                    self.searchDB.append(title)
                }
            }
            for (index, string) in self.searchDB.enumerated() {
                self.numberLabels[index].text = string
        }
        
            for (index, label) in self.numberLabels.enumerated() {
                if index == 0{
                    label.textAlignment = .center
                }
                else if index == 1{
                    label.textAlignment = .center
                }
                else{
                    label.textAlignment = .right
                }
            label.frame = CGRect(x: index * 130, y: 0, width: 70, height: 30)
            label.textColor = .black
            label.text = self.numberLabels[index].text
            self.customView.addSubview(label)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
                    label.isUserInteractionEnabled = true
                    label.addGestureRecognizer(tapGesture)
            }
        })
        
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel {
            inputTitle.text = label.text
        }
    }
        
    
    func textFieldDidBeginEditing(_ inputTitle: UITextField) {
            inputTitle.inputAccessoryView = customView
        }
    
    func defaultMenu(){
        let redComponents = self.defaultColor?.cgColor.components
        // redComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
        guard let r = redComponents?[0], let g = redComponents?[1], let b = redComponents?[2], let a = redComponents?[3] else {
            // 구성 요소를 가져오지 못한 경우
            return
        }
        // RGBA 값을 문자열로 변환
        let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)
        self.string = rgbaString
        self.notification = "no"
    }
    
    //Done 버튼 액션함수
    @IBAction func Done(_ sender: Any) {
    
        let preVC = self.presentingViewController
        guard let vc = preVC as? TableViewController else { return }

        if(inputTitle.text == ""){
            titleException.isHidden = false
        }
        else {
            if (titleException.isHidden == false){
                titleException.isHidden = true
            }
            vc.memoTitle.append(self.selectedTime + "$" + self.inputTitle.text! + "$" + self.string! + "$" + self.notification + "$" + self.check)
            
            if let text = inputTitle.text, !vc.searchDB.contains(text) {
                vc.searchDB.append(text)
            }
            
            if vc.searchDB.count > 3{
                vc.searchDB.removeFirst()
            }
            
            self.ref = Database.database().reference()
            let search = self.ref.child("\(vc.id)/recentSearch")
            search.setValue(vc.searchDB)
            
            let ref7 = Database.database().reference(withPath: "\(vc.id)/\(vc.date)/checkCount")
            ref7.observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? String ?? ""
                if value != "1"{
                    self.ref = Database.database().reference()
                    let checkCount = self.ref.child("\(vc.id)/\(vc.date)/checkCount")
                    checkCount.setValue("0")
                }
            })

            vc.memoRefresh()
            vc.tableView.reloadData()
            
            self.presentingViewController?.dismiss(animated: true) //ViewController로 이동
        }
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        
        self.presentingViewController?.dismiss(animated: true)
        
    }
    
    
    @IBAction func btnChiceColor(_ sender: Any) {
        guard let goadd = self.storyboard?.instantiateViewController(identifier: "Add_ColorViewController") as? Add_ColorViewController else {return}
        goadd.viewtype = "T"
        self.present(goadd, animated: true)
        
        guard let goChColor = self.storyboard?.instantiateViewController(identifier: "Add_ColorViewController") as? Add_ColorViewController else {return}
        self.present(goChColor, animated: true)
    
    }
    
    
    @IBAction func DatePicker(_ sender: UIDatePicker) {
        
        let datePickerView: UIDatePicker = sender
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        selectedTime = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func appearKeyboard(_ sender: Any) {
        self.inputTitle.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
