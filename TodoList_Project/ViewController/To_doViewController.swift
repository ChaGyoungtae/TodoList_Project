//
//  To-doViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/05/02.
//

import UIKit
import Firebase

class To_doViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dateDB : [String] = []
    var titleDB : [String] = []
    var timeDB : [String] = []
    var colorDB : [String] = []
    var checkDB : [String] = []
    var db : [String:Any] = [:]
    
    class ClassDate {
        var currentdate : String = ""
        var title : [String] = []
        var time : [String] = []
        var color : [String] = []
        var check : [String] = []
    }
    var cDate : [ClassDate] = [ClassDate]()
    
    var id = ""
    var str = ""
    var ref = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.id)
        
        print(dateDB)
        loadDB()
    }
    
    func loadDB() {
        ref.child(id).observeSingleEvent(of: .value) { snapshot in
            guard var dictionary = snapshot.value as? [String:Any] else {return}
            print("DEBUG: dictionary is \(dictionary)")
            print("--------")
            dictionary.removeValue(forKey: "title")
            dictionary.removeValue(forKey: "point")
            dictionary.removeValue(forKey: "game")
            dictionary.removeValue(forKey: "recentSearch")
            dictionary.removeValue(forKey: "combo")
            dictionary.removeValue(forKey: "check")
            //할일 외 데이터 삭제
            self.db = dictionary
            self.dateDB.append(contentsOf: self.db.keys)
            self.dateDB = self.dateDB.sorted(by: <)
            print(self.dateDB)
            for i in 0..<self.dateDB.count {
                let date = self.dateDB[i]   //데이터가 있는 날짜 받아와서 다시 데이터 받아오기
                
                let ref2 = Database.database().reference(withPath:"\(self.id)/\(date)/title")
                ref2.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                           let title = snapshot.value as? String {
                            self.titleDB.append(title)
                        }
                    }
                    self.cDate.append(ClassDate())
                    self.cDate[i].currentdate = date
                    self.cDate[i].title = self.titleDB
                    self.titleDB.removeAll()
                    let ref3 = Database.database().reference(withPath: "\(self.id)/\(date)/color")
                    ref3.observeSingleEvent(of: .value, with: { snapshot in
                        for child in snapshot.children {
                            if let snapshot = child as? DataSnapshot,
                               let color = snapshot.value as? String {
                                self.colorDB.append(color)
                            }
                        }
                        self.cDate[i].color = self.colorDB
                        self.colorDB.removeAll()
                        let ref4 = Database.database().reference(withPath: "\(self.id)/\(date)/time")
                        ref4.observeSingleEvent(of: .value, with: {
                            snapshot in
                            for child in snapshot.children {
                                if let snapshot = child as? DataSnapshot,
                                   let time = snapshot.value as? String {
                                    self.timeDB.append(time)
                                }
                            }
                            self.cDate[i].time = self.timeDB
                            self.timeDB.removeAll()
                            let ref5 = Database.database().reference(withPath: "\(self.id)/\(date)/check")
                            ref5.observeSingleEvent(of: .value, with: {
                                snapshot in
                                for child in snapshot.children {
                                    if let snapshot = child as? DataSnapshot,
                                       let check = snapshot.value as? String {
                                        self.checkDB.append(check)
                                    }
                                }
                                self.cDate[i].check = self.checkDB
                                self.checkDB.removeAll()
                                
                                
                                /*
                                 print(self.titleDB)
                                 print("------")
                                 print(self.timeDB)
                                 print("------")
                                 print(self.colorDB)
                                 print("------")
                                 */
                                if(i == self.dateDB.count-1) {
                                    self.tableView.reloadData()
                                }
                            })
                        })
                    })
                })
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateDB.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateDB[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? todo_cell else { return UITableViewCell()}
        
        
        
        var colorString = ""
        
        if indexPath.section == 0 {
            cell.title.text = self.cDate[indexPath.section].title[indexPath.row]
            cell.time.text = self.cDate[indexPath.section].time[indexPath.row]
            
            // rgba가 저장된 string문자열을 다시 rgba값으로 변환
            colorString = self.cDate[indexPath.section].color[indexPath.row]
            if(self.cDate[indexPath.section].check[indexPath.row] == "green") {
                cell.check.tintColor = .green
            }
            else {
                cell.check.tintColor = .black
            }
           
            
            
        }
        else {
            cell.title.text = self.cDate[indexPath.section].title[indexPath.row]
            cell.time.text = self.cDate[indexPath.section].time[indexPath.row]
            colorString = self.cDate[indexPath.section].color[indexPath.row]
            if(self.cDate[indexPath.section].check[indexPath.row] == "green") {
                cell.check.tintColor = .green
            }
            else {
                cell.check.tintColor = .black
            }
        }
        
        let components = colorString.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: ",")
                let red = CGFloat((components[0] as NSString).floatValue)
                let green = CGFloat((components[1] as NSString).floatValue)
                let blue = CGFloat((components[2] as NSString).floatValue)
                let alpha = CGFloat((components[3] as NSString).floatValue)
                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        cell.color.backgroundColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return self.cDate[section].title.count
        }
        else {
            return self.cDate[section].title.count
        }
    }
    
    
    @IBAction func btnSomeday(_ sender: Any) {
        guard let goSomeday = self.storyboard?.instantiateViewController(identifier: "SomedayViewController") as? SomedayViewController else {return}
        goSomeday.id = self.id
        self.present(goSomeday, animated: true, completion: nil)
    }
    
    @IBAction func btnCal(_ sender: Any) {
        guard let goCal = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalenderViewController else {return}
        goCal.id = self.id
        goCal.modalPresentationStyle = .fullScreen
        self.present(goCal, animated: true, completion: nil)
    }
    
}
class todo_cell : UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var time : UILabel!
    @IBOutlet weak var color : UIButton!
    @IBOutlet weak var check : UIButton!
    
}
