//
//  CalenderViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/03/29.
//

import UIKit
import FSCalendar
import Firebase

class CalenderViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    //다중선택 날짜 저장
    var multipleDate : [String] = []
    
    var id = ""
    var t = 100
    var value = ""
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var point: UILabel!
    
    @IBOutlet weak var comboLable: UILabel!
 
    @IBOutlet weak var Remove: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.calendarView.backgroundColor = .white
        CalendarSet()
        loadCombo()
        loadPoint()
        calendarCurrentPageDidChange(calendarView)
        calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CalendarSet()
        calendarCurrentPageDidChange(calendarView)
        calendarView.reloadData()
        loadPoint()
    }
    
    func loadCombo(){
        let ref = Database.database().reference(withPath: "\(self.id)/combo")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let combo = snapshot.value as? String ?? ""
            if combo == "2"{
                self.comboLable.textColor = .blue
                self.comboLable.text = "3일 연속 콤보 (+5)"
            }
            else if combo == "3"{
                self.comboLable.textColor = .blue
                self.comboLable.text = "4일 연속 콤보 (+10)"
            }
            else if combo == "4"{
                self.comboLable.textColor = UIColor(named: "Purple")
                self.comboLable.text = "5일 연속 콤보 (+15)"
            }
            else if combo == "5"{
                self.comboLable.textColor = UIColor(named: "Purple")
                self.comboLable.text = "6일 연속 콤보 (+20)"
            }
            else if combo == "6"{
                self.comboLable.font = UIFont.boldSystemFont(ofSize: 17)
                self.comboLable.textColor = UIColor(named: "7일이상")
                self.comboLable.text = "7일이상 연속 콤보! (+25)"
            }
            else{
                
                self.comboLable.textColor = .black
                self.comboLable.text = "콤보 미적용 중 (+0)"
            }
        })
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        for i in 100...t{
            let viewWithTag = self.view.viewWithTag(i)
            viewWithTag?.removeFromSuperview()
        }
        t = 100
    }
    
    func CalendarSet() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerDateFormat  = "YYYY년 M월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.todayColor = .white
        calendarView.appearance.titleTodayColor = UIColor(named: "Today")
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.selectionColor = .clear
        Remove.isHidden = true //처음에는 삭제 메세지 안보이게 설정
        
    }
    
    func loadPoint() {
        let ref = Database.database().reference(withPath: "\(self.id)/point")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? String ?? ""
            self.point.text = value
        })
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //다중선택 아닐때
        if(calendarView.allowsMultipleSelection == false) {
            guard let goTable = self.storyboard?.instantiateViewController(identifier: "TableViewController") as? TableViewController else {return}
            
            goTable.id = id
            goTable.date = dateFormatter.string(from: date)
            goTable.modalPresentationStyle = .overFullScreen
            self.view.backgroundColor = .lightGray
            self.calendarView.backgroundColor = .lightGray
            calendar.deselect(date)
            self.present(goTable, animated: true, completion: nil)
        }
        //다중선택일때
        else {
            //선택한 날짜들을 중복없이 집합에 넣음
            multipleDate.append(dateFormatter.string(from: date))
        }
    }
    
    //선택해제될때
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //삭제모드일때
        if  (calendarView.allowsMultipleSelection == true) {
            //선택해제된 날짜 삭제
            if let idx = multipleDate.firstIndex(of: dateFormatter.string(from: date)){
                multipleDate.remove(at: idx)
            }
            //multipleDate.remove(dateFormatter.string(from: date))
        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter : DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var Date = dateFormatter.string(from: date)
        
        func makelbl(str : String, y : Int, color: String, check : String){
            
            // rgba가 저장된 string문자열을 다시 rgba값으로 변환
            let colorString = color
            let components = colorString.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: ",")
            let red = CGFloat((components[0] as NSString).floatValue)
            let green = CGFloat((components[1] as NSString).floatValue)
            let blue = CGFloat((components[2] as NSString).floatValue)
            let alpha = CGFloat((components[3] as NSString).floatValue)
            let tcolor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            
            let check = check
            
            let labelMy = UILabel(frame: CGRect(x: 5, y: y, width: Int(cell.bounds.width)-8, height: 17))
            labelMy.font = UIFont(name: "Henderson BCG Sans", size: 8)
            labelMy.font = UIFont.systemFont(ofSize: 11)
            labelMy.text = str
            if (check == "green") {
                labelMy.attributedText = labelMy.text?.strikeThrough()
            }
            labelMy.layer.cornerRadius = cell.bounds.width/2
            labelMy.textColor = UIColor(named: "White")
            labelMy.backgroundColor = tcolor
            labelMy.tag = self.t
            self.t+=1
            cell.addSubview(labelMy)
        }

        
        var lblTodo = [String?]()
        var lblTodoColor = [String?]()
        var lblTodoCheck = [String?]()
        
        let ref = Database.database().reference(withPath:"\(self.id)/\(Date)/title")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let title = snapshot.value as? String {
                    lblTodo.append(title)
                }
            }
            let ref2 = Database.database().reference(withPath: "\(self.id)/\(Date)/color")
            ref2.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let color = snapshot.value as? String {
                        lblTodoColor.append(color)
                    }
                }
                let ref3 = Database.database().reference(withPath: "\(self.id)/\(Date)/check")
                ref3.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                           let check = snapshot.value as? String {
                            lblTodoCheck.append(check)
                        }
                    }
                    if(lblTodo.isEmpty == false){
                        //print("date = " + Date)
                        //print(lblTodoColor)
                        //print(lblTodo)
                        for i in 0..<lblTodo.count {
                            if(i > 4) {
                                break
                            }
                            // 레이블만들기
                            makelbl(str: lblTodo[i]!, y: 40 + 15*(i+1), color: lblTodoColor[i]!,check: lblTodoCheck[i]!)
                        }
                    }
                    lblTodo.removeAll()
                    lblTodoColor.removeAll()
                    lblTodoCheck.removeAll()
                })
            })
        })
  
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 사이드 메뉴 연결
    @IBAction func buttonClicked(_ sender: Any) {
            //스토리보드
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            //사이드메뉴 뷰컨트롤러 객체 생성
            let sideMenuViewController: SideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            
            //커스텀 네비게이션이랑 사이드메뉴 뷰컨트롤러 연결
            let menu = CustomSideMenuNavigation(rootViewController: sideMenuViewController)
            
            sideMenuViewController.id = self.id
            //보여주기
            present(menu, animated: true, completion: nil)
        }

    
        
    @IBAction func btnSomeday(_ sender: Any) {
        guard let goSomeday = self.storyboard?.instantiateViewController(identifier: "SomedayViewController") as? SomedayViewController else {return}
        goSomeday.id = self.id
        self.present(goSomeday, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTodo(_ sender: UIButton) {
        guard let goTodo = self.storyboard?.instantiateViewController(identifier: "To_doViewController") as? To_doViewController else {return}
        goTodo.id = id
        goTodo.modalPresentationStyle = .fullScreen
        self.present(goTodo, animated: true, completion: nil)
    }
    
    //휴지통 버튼 누르면
    @IBAction func btnRemove(_ sender: Any) {
        //삭제모드 아닐때 삭제모드로 전환
        if (calendarView.allowsMultipleSelection == false){
            Remove.isHidden = false
            calendarView.allowsMultipleSelection = true
            calendarView.appearance.selectionColor = UIColor(named: "Deep Blue")
            calendarView.appearance.titleSelectionColor = .white
        }
        //삭제모드 일때
        else {
            //저장된 날짜들 출력하고 삭제
            //print(multipleDate)
            rmTodo(dates: multipleDate)
            multipleDate.removeAll()
            Remove.isHidden = true
            calendarView.allowsMultipleSelection = false
            calendarView.appearance.selectionColor = .clear
            calendarView.appearance.titleSelectionColor = .black
        }
    }
    
    //삭제 모드때 선택된 날짜들의 투두리스트 삭제
    func rmTodo(dates : [String]){
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 0..<multipleDate.count {
            print(multipleDate[i])
            let Ref = Database.database().reference().child("\(self.id)/\(multipleDate[i])")
            Ref.removeValue()
            calendarView.deselect(dateFormatter.date(from: multipleDate[i])!)
        }
        self.viewWillAppear(true)
    }
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
