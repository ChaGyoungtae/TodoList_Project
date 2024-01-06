//
//  ViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/02/07.
//

import UIKit
import Firebase
import UserNotifications

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblModify: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectedDate: UILabel!
    
    //투두를 저장할 배열
    var memoTitle = [String?]()
    // DB 저장 경로
    var id = "" // 아이디
    var date = "" // 날짜
    var point = 10 // 포인트
    
    //DB에 저장되어있는 데이터들을 가져올때 사용할 변수들
    var titleDB : [String] = []
    var timeDB : [String] = []
    var colorDB : [String] = []
    var notificationDB : [String] = []
    var checkDB : [String] = []
    var pointDB : String = ""
    var checkCountDB : String = ""
    var searchDB : [String] = []
    
    //DB에 데이터를 넣을때 사용하는 변수
    var ref : DatabaseReference!
    
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        selectedDate.text = date
        self.lblModify.isHidden = true
        loadDB()
    }
    
    func requestSendNotification(seconds: String, text: String, time: String) {
        if time != "no"{
            let content = UNMutableNotificationContent()
            content.title = "할 일이 있습니다!"
            content.subtitle = selectedDate.text! + " " + seconds
            content.body = text
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            // 입력한 날짜와 시간을 가져옴
            let str = selectedDate.text! + " " + seconds
            let date = dateFormatter.date(from: str)!
            
            // 현재 시간을 가져옴
            let currentDate = Date()
            
            // time 변수를 초 단위로 변환
            let timeInSeconds = Int(time) ?? 0
            
            // 입력한 날짜와 시간에서 timeInSeconds를 뺀 시간을 구함
            let notificationDate = date.addingTimeInterval(TimeInterval(-timeInSeconds))
            
            // notificationDate의 components를 가져옴
            let calendar = Calendar.current
            let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            
            // 현재 날짜와 시간을 calendar로 변환하여 components를 가져옴
            let currentComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
            
            
            // 입력한 날짜와 시간이 현재 시간 이전이라면, 알림을 추가하지 않음
            if triggerDate.year! >= currentComponents.year!
                && triggerDate.month! >= currentComponents.month!
                && triggerDate.day! >= currentComponents.day!
                && triggerDate.hour! >= currentComponents.hour!
                && triggerDate.minute! >= currentComponents.minute! {
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // TableViewController로 넘어올때마다 DB에 값 넘어오고 memotitle 갱신
    func loadDB() {
        var ti = [String]()
        let ref1 = Database.database().reference(withPath: "\(self.id)/\(self.date)/time")
        ref1.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let time = snapshot.value as? String {
                    ti.append(time)
                }
            }
            
            self.timeDB.removeAll()
            self.timeDB = ti
            ti.removeAll()
            
            let ref2 = Database.database().reference(withPath:"\(self.id)/\(self.date)/title")
            ref2.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let title = snapshot.value as? String {
                        ti.append(title)
                    }
                }
                self.titleDB.removeAll()
                self.titleDB = ti
                ti.removeAll()
                
                let ref4 = Database.database().reference(withPath: "\(self.id)/\(self.date)/notification")
                ref1.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                           let notification = snapshot.value as? String {
                            ti.append(notification)
                        }
                    }
                    self.notificationDB.removeAll()
                    self.notificationDB = ti
                    ti.removeAll()
                    
                    let ref3 = Database.database().reference(withPath: "\(self.id)/\(self.date)/color")
                    ref3.observeSingleEvent(of: .value, with: { snapshot in
                        for child in snapshot.children {
                            if let snapshot = child as? DataSnapshot,
                               let color = snapshot.value as? String {
                                ti.append(color)
                            }
                        }
                        
                        self.colorDB.removeAll()
                        self.colorDB = ti
                        ti.removeAll()
                        
                        let ref5 = Database.database().reference(withPath: "\(self.id)/\(self.date)/check")
                        ref5.observeSingleEvent(of: .value, with: { snapshot in
                            for child in snapshot.children {
                                if let snapshot = child as? DataSnapshot,
                                   let check = snapshot.value as? String {
                                    ti.append(check)
                                }
                            }
                            self.checkDB.removeAll()
                            self.checkDB = ti
                            ti.removeAll()
                            
                            let ref6 = Database.database().reference(withPath: "\(self.id)/point")
                            ref6.observeSingleEvent(of: .value, with: { snapshot in
                                let value = snapshot.value as? String ?? ""
                                self.pointDB = value
                                
                                let ref7 = Database.database().reference(withPath: "\(self.id)/\(self.date)/checkCount")
                                ref7.observeSingleEvent(of: .value, with: { snapshot in
                                    let value = snapshot.value as? String ?? ""
                                    self.checkCountDB = value
                                    
                                    let ref8 = Database.database().reference(withPath:"\(self.id)/recentSearch")
                                    ref8.observeSingleEvent(of: .value, with: { snapshot in
                                        for child in snapshot.children {
                                            if let snapshot = child as? DataSnapshot,
                                               let title = snapshot.value as? String {
                                                ti.append(title)
                                            }
                                        }
                                        self.searchDB.removeAll()
                                        self.searchDB = ti
                                        ti.removeAll()
                                        
                                        
                                        var tmparr = [String]()
                                        for idx in 0..<self.timeDB.count {
                                            tmparr.append(self.timeDB[idx] + "$" + self.titleDB[idx] + "$" + self.colorDB[idx] + "$" + self.notificationDB[idx] + "$" + self.checkDB[idx])
                                        }
                                        tmparr = tmparr.sorted(by: <)
                                        self.memoTitle.removeAll()
                                        self.memoTitle = tmparr
                                        if(self.memoTitle.isEmpty == false){
                                            self.tableView.reloadData()
                                        }
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }
    //메모 타이틀 갱신 후 데베에 저장
    func memoRefresh() {
        let sortedArray = memoTitle.sorted {
            (lhs, rhs) -> Bool in
            if lhs == nil && rhs == nil {
                return false
            }
            else if lhs == nil {
                return false
            }
            else if rhs == nil {
                return true
            }
            else {
                return lhs! < rhs!
                }
            }
        memoTitle.removeAll()
        memoTitle = sortedArray
            
        //memoTitle에 "시간 + 할일 + 색깔" 로 저장되어있는 문자열들을 공백을 기준으로 나누어 각각 timeDB, titleDB, colorDB에 저장
        var tmpMemo = [String]()
        titleDB.removeAll()
        timeDB.removeAll()
        notificationDB.removeAll()
        colorDB.removeAll()
        checkDB.removeAll()
        center.removeAllPendingNotificationRequests() // 전체 알림 삭제
        for element in memoTitle {
            if let value = element {
                tmpMemo = value.components(separatedBy: "$")
                timeDB.append(tmpMemo[0])
                titleDB.append(tmpMemo[1])
                colorDB.append(tmpMemo[2])
                notificationDB.append(tmpMemo[3])
                checkDB.append(tmpMemo[4])
                requestSendNotification(seconds: String(tmpMemo[0]), text: String(tmpMemo[1]), time: String(tmpMemo[3])) // DB에 새로 저장된 알림 다시저장
            }
        }
        // DB 내 list/time 과 list/title, list/color에 각각 시간과 할일, 색깔 저장
        self.ref = Database.database().reference()
        let timeRef = self.ref.child("\(self.id)/\(self.date)/time")
        let titleRef = self.ref.child("\(self.id)/\(self.date)/title")
        let colorRef = self.ref.child("\(self.id)/\(self.date)/color")
        let notificationRef = self.ref.child("\(self.id)/\(self.date)/notification")
        let checkRef = self.ref.child("\(self.id)/\(self.date)/check")
        timeRef.setValue(timeDB)
        titleRef.setValue(titleDB)
        colorRef.setValue(colorDB)
        notificationRef.setValue(notificationDB)
        checkRef.setValue(checkDB)

        }
    
    //tableView delegate 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoTitle.count
    }
    
    //memotitle의 각 원소들(시간+할일의 형태)을 시간과 할일로 각각 나누어 테이블뷰에 나타나게 하는 코드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else { return UITableViewCell()}
        
        var data = [String]()
        if let tmp = memoTitle[indexPath.row]{
            data = tmp.components(separatedBy: "$")
            cell.labelTime.text = String(data[0])
            cell.labelTitle.text = String(data[1])
            if(data[4] == "black"){
                cell.checkMark.tintColor = .black
            }
            else {
                cell.checkMark.tintColor = .green
            }
            // rgba가 저장된 string문자열을 다시 rgba값으로 변환
            let colorString = String(data[2])
            let components = colorString.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: ",")
                    let red = CGFloat((components[0] as NSString).floatValue)
                    let green = CGFloat((components[1] as NSString).floatValue)
                    let blue = CGFloat((components[2] as NSString).floatValue)
                    let alpha = CGFloat((components[3] as NSString).floatValue)
                    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            
            cell.ColorButton.backgroundColor = color
            cell.ColorButton.layer.cornerRadius = 5
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.lblModify.isHidden == false){ //수정모드
            guard let gomod = self.storyboard?.instantiateViewController(identifier: "ModifyViewController") as? ModifyViewController else {return}
            
            let selectedIndex = indexPath.row
            gomod.prepareTitle = memoTitle[selectedIndex]!
            print(memoTitle[selectedIndex]!)
            gomod.prepareIndex = selectedIndex
            gomod.prepareDate = selectedDate.text!
            gomod.modalPresentationStyle = .overFullScreen
            self.present(gomod, animated: true)
        }
        else { //할일 체크
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Date()
            guard let date = dateFormatter.date(from: self.date) else {
                fatalError("날짜 변환 실패")
            }
            let currentDateFormatted = dateFormatter.string(from: currentDate)
            let dateFormatted = dateFormatter.string(from: date)
            
            if currentDateFormatted > dateFormatted {
                let cell = tableView.cellForRow(at:  indexPath) as! CustomCell
                if(cell.checkMark.tintColor == .black) {
                    let blackToGreen = UIAlertController(title: "할일체크", message: "체크하시겠습니까?\n(주의 : 되돌릴 수 없습니다. 또한 Combo가 적용되지 않습니다.)", preferredStyle: UIAlertController.Style.alert)
                    let checkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default,
                                                    handler: {(action: UIAlertAction) -> Void in
                        cell.checkMark.tintColor = .green
                        self.nocomboCheck("green",indexPath.row)
                    })
                    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
                    blackToGreen.addAction(checkAction)
                    blackToGreen.addAction(cancelAction)
                    
                    present(blackToGreen, animated: true, completion: nil)
                }
            }
            /*else if currentDateFormatted < dateFormatted{
                let blackToGreen = UIAlertController(title: "할일체크", message: "해당 날짜는 체크가 불가능합니다.", preferredStyle: UIAlertController.Style.alert)
                let checkAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default,
                                                handler: {(action: UIAlertAction) -> Void in
                })
                blackToGreen.addAction(checkAction)
                present(blackToGreen, animated: true, completion: nil)
                
            }*/
            else{
                let cell = tableView.cellForRow(at:  indexPath) as! CustomCell
                if(cell.checkMark.tintColor == .black) {
                    let blackToGreen = UIAlertController(title: "할일체크", message: "체크하시겠습니까?\n(주의 : 되돌릴 수 없습니다.)", preferredStyle: UIAlertController.Style.alert)
                    let checkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default,
                                                    handler: {(action: UIAlertAction) -> Void in
                        cell.checkMark.tintColor = .green
                        self.checkorNot("green",indexPath.row)
                    })
                    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
                    blackToGreen.addAction(checkAction)
                    blackToGreen.addAction(cancelAction)
                    
                    present(blackToGreen, animated: true, completion: nil)
                }
            }
            
        }
    }
    //체크 여부를 db에 저장해주는 메서드
    func checkorNot(_ value: String, _ index: Int){
        guard let goCal = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalenderViewController else {return}
        
        self.checkDB[index] = value
        //print(self.checkDB[index])
        self.ref = Database.database().reference()
        let checkRef = self.ref.child("\(self.id)/\(self.date)/check")
        checkRef.setValue(self.checkDB)
        
        self.checkCountDB = "1"
        let checkCount = self.ref.child("\(self.id)/\(self.date)/checkCount")
        checkCount.setValue(self.checkCountDB)
        
        let databaseRef = Database.database().reference()
        let idRef = databaseRef.child(self.id)
        
        idRef.observeSingleEvent(of: .value) { snapshot in
            guard let datesSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            let allDates = datesSnapshot.compactMap { $0.key } // DB에 저장된 날짜 배열에 저장
            
            var minus = 1 // 날짜를 뺄 변수
            var combo = 0 // 콤보를 확인할 변수
            var checkCount = "" // checkCount를 저장할 변수
            var currentDate = self.date // 현재 날짜 저장할 변수
            
            let dateFormatter = DateFormatter() // string -> date
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            var date = dateFormatter.date(from: currentDate) // 문자열을 DATE형으로 변환
            let calendar = Calendar.current
            
            

            for _ in 1...6{
                var newDate = calendar.date(byAdding: .day, value: -minus, to: date!) // 현재 날짜에서 하루전 날짜
                let formattedDate = dateFormatter.string(from: newDate!)

                for i in allDates {
                    if i == formattedDate{
                        print(i)
                        minus = minus + 1
                        let ref = Database.database().reference(withPath: "\(self.id)/\(i)/checkCount")
                        ref.observeSingleEvent(of: .value, with: { snapshot in
                            let value = snapshot.value as? String ?? ""
                            checkCount = value

                            if checkCount == "1"{
                                combo = combo + 1
                            }
                            else{
                                combo = 0
                            }

                            if combo == 2{
                                print("plus point 15")
                                let comboRef = self.ref.child("\(self.id)/combo")
                                comboRef.setValue("2")
                                var pt = Int(self.pointDB)!
                                pt += 15
                                let pointRef = self.ref.child("\(self.id)/point")
                                pointRef.setValue(String(pt))
                            }
                            else if combo == 3{
                                print("plus point 20")
                                let comboRef = self.ref.child("\(self.id)/combo")
                                comboRef.setValue("3")
                                var pt = Int(self.pointDB)!
                                pt += 20
                                let pointRef = self.ref.child("\(self.id)/point")
                                pointRef.setValue(String(pt))
                            }
                            else if combo == 4{
                                print("plus point 25")
                                let comboRef = self.ref.child("\(self.id)/combo")
                                comboRef.setValue("4")
                                var pt = Int(self.pointDB)!
                                pt += 25
                                let pointRef = self.ref.child("\(self.id)/point")
                                pointRef.setValue(String(pt))
                            }
                            else if combo == 5{
                                print("plus point 30")
                                let comboRef = self.ref.child("\(self.id)/combo")
                                comboRef.setValue("5")
                                var pt = Int(self.pointDB)!
                                pt += 30
                                let pointRef = self.ref.child("\(self.id)/point")
                                pointRef.setValue(String(pt))
                            }
                            if combo == 6{
                                print("plus point 35")
                                let comboRef = self.ref.child("\(self.id)/combo")
                                comboRef.setValue("6")
                                var pt = Int(self.pointDB)!
                                pt += 35
                                let pointRef = self.ref.child("\(self.id)/point")
                                pointRef.setValue(String(pt))
                            }
                        })
                    }
    
                }
            }
        }
        
        var pt = Int(self.pointDB)!
        pt += self.point
        let pointRef = self.ref.child("\(self.id)/point")
        pointRef.setValue(String(pt))
        let comboRef = self.ref.child("\(self.id)/combo")
        comboRef.setValue("0")
        // 여러번 한 일이면 self.point +=5 -> 이런식으로

        viewDidLoad()
    }
    // combo가 적용되지 않는 포인트 획득
    func nocomboCheck(_ value: String, _ index: Int){
        self.checkDB[index] = value
        //print(self.checkDB[index])
        self.ref = Database.database().reference()
        let checkRef = self.ref.child("\(self.id)/\(self.date)/check")
        checkRef.setValue(self.checkDB)
        
        var pt = Int(self.pointDB)!
        pt += self.point
        let pointRef = self.ref.child("\(self.id)/point")
        pointRef.setValue(String(pt))

        viewDidLoad()
    }
    
    // 테이블 뷰에 원하는 투두를 스와이프로 삭제 후 viewWillAppear 메서드 실행으로 테이블뷰 갱신
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memoTitle.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.memoRefresh()
            // 테이블뷰 갱신
            self.tableView.reloadData()
        }
        else if editingStyle == .insert {
        }
    }
    
    
    
    @IBAction func btnadd(_ sender: Any) {
        guard let goadd = self.storyboard?.instantiateViewController(identifier: "AddViewController") as? AddViewController else {return}
        goadd.currentDate = self.date
        goadd.modalPresentationStyle = .currentContext
        self.present(goadd, animated: true, completion: nil)
    }
    
    
    @IBAction func goCalender(_ sender: Any) {
        self.presentingViewController?.viewDidLoad()
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    @IBAction func btnSomeday(_ sender: Any) {
        guard let goSomeday = self.storyboard?.instantiateViewController(identifier: "SomedayViewController") as? SomedayViewController else {return}
        goSomeday.id = self.id
        self.present(goSomeday, animated: true, completion: nil)
    }
    
    
    @IBAction func modifyMod(_ sender: Any) {
        if (self.lblModify.isHidden == false) {
            self.lblModify.isHidden = true
        }
        else {
            self.lblModify.isHidden = false
        }
    }
    
}
    
class CustomCell: UITableViewCell {
        
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var ColorButton: UIButton!
    @IBOutlet weak var checkMark: UIButton!
    
}
extension TableViewController : UNUserNotificationCenterDelegate {
    //To display notifications when app is running  inforeground
    
    //앱이 foreground에 있을 때. 즉 앱안에 있어도 push알림을 받게 해줍니다.
    //viewDidLoad()에 UNUserNotificationCenter.current().delegate = self를 추가해주는 것을 잊지마세요.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .gray
        self.present(settingsViewController, animated: true, completion: nil)
        
    }
    
    
    
}

