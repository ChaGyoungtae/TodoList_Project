//
//  ViewController3.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/02/10.
//

import UIKit
//할일 수정
class ModifyViewController: UIViewController {
    var prepareIndex : Int?
    var prepareTime = ""
    var prepareTitle = ""
    var prepareColor = ""
    var prepareDate = ""
    var notification = ""
    var check = ""
    
    @IBOutlet weak var titleException: UILabel!
    
    @IBOutlet weak var dateLable: UILabel!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var chgColor: UIButton!
    
    @IBOutlet weak var notificationButton: UIButton!
    
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
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        //vc1에서 받아온 문자열을 공백기준으로 나누어서 시간, 할일을 각각 보여줌
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        titleException.isHidden = true
        self.view.backgroundColor = .clear
        let tmp = prepareTitle
        let str = tmp.split(separator: "$")
        prepareTime = String(str[0])
        let selectedTime = dateFormatter.date(from: prepareTime)!
        self.datePicker.date = selectedTime
        titleText.text = String(str[1])
        dateLable.text = prepareDate
        prepareColor = String(str[2])
        notification = String(str[3])
        check = String(str[4])
        notificationButton.menu = menu
        notificationButton.showsMenuAsPrimaryAction = true
    
        let colorString = prepareColor
        let components = colorString.replacingOccurrences(of: "rgba(", with:"").replacingOccurrences(of: ")", with: "").components(separatedBy: ",")
            let red = CGFloat((components[0] as NSString).floatValue)
            let green = CGFloat((components[1] as NSString).floatValue)
            let blue = CGFloat((components[2] as NSString).floatValue)
            let alpha = CGFloat((components[3] as NSString).floatValue)
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        chgColor.backgroundColor = color
        chgColor.layer.cornerRadius = 6
        
        }
    

    
    //Done버튼 누르면 입력한 시간과 할일로 수정되어 vc1로 넘어가짐 (컬러랑 알람 문자열로 넘겨줘야함)
    @IBAction func btnDone(_ sender: UIButton) {
        let preVC = self.presentingViewController
        guard let vc = preVC as? TableViewController else { return }
        if titleText.text! != ""{
            titleException.isHidden = true
            vc.memoTitle[prepareIndex!] = prepareTime + "$" + titleText.text! + "$" + prepareColor + "$" + notification + "$" + check
            
            vc.memoRefresh()
            vc.tableView.reloadData()
            
            vc.lblModify.isHidden = true
            self.presentingViewController?.dismiss(animated: true)
        }
        else{
            titleException.isHidden = false
        }
        
    }
    
    
    @IBAction func changeColor(_ sender: Any) {
        guard let goadd = self.storyboard?.instantiateViewController(identifier: "Add_ColorViewController") as? Add_ColorViewController else {return}
        goadd.viewtype = "F"
        self.present(goadd, animated: true)
        
        if let addColor = storyboard?.instantiateViewController(withIdentifier: "Add_ColorViewController") as? Add_ColorViewController {
            self.present(addColor, animated: true)
        }

    }
    
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let preVC = self.presentingViewController
        guard preVC is TableViewController else { return }

        let datePickerView: UIDatePicker = sender
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        prepareTime = formatter.string(from: datePickerView.date)
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true)
        
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
    

