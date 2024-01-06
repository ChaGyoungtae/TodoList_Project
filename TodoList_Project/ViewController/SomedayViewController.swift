//
//  SomedayViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/04/07.
//

import UIKit
import Firebase

class SomedayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var somedayTable: UITableView!
    
    @IBOutlet weak var inputTitle: UITextField!
    
    @IBOutlet weak var titleException: UILabel!
    
    @IBOutlet weak var btnAddorModify: UIButton!
    
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var modifyLabel: UILabel!
    
    var memoTitle = [String?]()
    var modifyidx = 0
    var checkDB = [String]()
    // DB 저장 경로
    var id = ""
    
    //DB에 데이터를 넣을때 사용하는 변수
    var ref : DatabaseReference!
    
    //DB에 저장되어있는 데이터들을 가져올때 사용할 변수들
    var titleDB : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleException.isHidden = true
        modifyLabel.isHidden = true
        btnAddorModify.setTitle("입력", for: .normal)
        loadSomeday()
        // Do any additional setup after loading the view.
    }
    //처음에 데베에서 데이터 가져오기
    func loadSomeday(){
        var ti = [String]()
        let ref = Database.database().reference(withPath: "\(self.id)/title")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let title = snapshot.value as? String {
                    self.memoTitle.append(title)
                }
            }
            let ref2 = Database.database().reference(withPath: "\(self.id)/check")
            ref2.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let check = snapshot.value as? String {
                        ti.append(check)
                    }
                }
                self.checkDB.removeAll()
                self.checkDB = ti
                print(self.checkDB)
                
                self.somedayTable.reloadData()
            })
        })
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let somedaycell = somedayTable.dequeueReusableCell(withIdentifier: "somedaycell", for: indexPath) as? SomedayCustomCell else { return UITableViewCell()}
        
        if let temp = memoTitle[indexPath.row]
        {
            somedaycell.labelTitle.text = temp
        }
        
        let check = self.checkDB[indexPath.row]
        if check == "green"{
            somedaycell.checkMark.tintColor = .green
        }
        else if check == "black"{
            somedaycell.checkMark.tintColor = .black
        }

        return somedaycell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.modifyLabel.isHidden == false){
            self.inputTitle.isHidden = false
            self.btnAddorModify.isHidden = false
            self.btnModify.isHidden = true
            inputTitle.text = memoTitle[indexPath.row]
            
            btnAddorModify.setTitle("수정", for: .normal)
            self.modifyidx = indexPath.row
        }
        else{
            let cell = tableView.cellForRow(at:  indexPath) as! SomedayCustomCell
            if(cell.checkMark.tintColor == .black){
                let blackToGreen = UIAlertController(title: "할일체크", message: "체크하시겠습니까?\n(주의 : 되돌릴 수 없습니다.)", preferredStyle: UIAlertController.Style.alert)
                let checkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default,
                                                handler: {(action: UIAlertAction) -> Void in
                    cell.checkMark.tintColor = .green
                    self.checkDB[indexPath.row] = "green"
                    self.ref = Database.database().reference()
                    let somedayRef2 = self.ref.child("\(self.id)/check")
                    somedayRef2.setValue(self.checkDB)
                    
                    
                    
                    let refs = Database.database().reference(withPath: "\(self.id)/point")
                    refs.observeSingleEvent(of: .value, with: { snapshot in
                        let value = snapshot.value as? String ?? ""
                        var point = Int(value)!
                        point += 10
                        let pointRef = self.ref.child("\(self.id)/point")
                        pointRef.setValue(String(point))
                    })

                })
                let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
                blackToGreen.addAction(checkAction)
                blackToGreen.addAction(cancelAction)
                
                present(blackToGreen, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func modifyButton(_ sender: UIButton) {
        
        if(self.modifyLabel.isHidden == true){
            self.titleException.isHidden = true
            self.modifyLabel.isHidden = false
            self.inputTitle.isHidden = true
            self.btnAddorModify.isHidden = true
        }
        else {
            self.modifyLabel.isHidden = true
            self.inputTitle.isHidden = false
            self.btnAddorModify.isHidden = false
        }
    }
    
    //추가
    @IBAction func addTitle(_ sender: Any) {
        self.modifyLabel.isHidden = true
        if inputTitle.text == "" {
            titleException.isHidden = false
        }
        else {
            if btnAddorModify.title(for: .normal) == "입력" {
                memoTitle.append(inputTitle.text)
            let black = "black"
                self.checkDB.append(black)
                print(checkDB)
            }
            else {
                memoTitle[modifyidx] = inputTitle.text
                btnAddorModify.setTitle("입력", for: .normal)
                self.btnModify.isHidden = false
            }
            titleException.isHidden = true
            self.somedayRefresh()
            inputTitle.text = ""
            }
    }
    
    //할일 추가, 삭제할때마다 갱신
    func somedayRefresh(){
        
        let somedayRef = Database.database().reference().child("\(self.id)/title")
        somedayRef.setValue(memoTitle)
        let somedayRef2 = Database.database().reference().child("\(self.id)/check")
        somedayRef2.setValue(checkDB)
        
        self.somedayTable.reloadData()
        
    }
    
    // 테이블 뷰에 원하는 투두를 스와이프로 삭제 후 viewWillAppear 메서드 실행으로 테이블뷰 갱신
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memoTitle.remove(at: indexPath.row)
            checkDB.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            somedayRefresh()
            self.inputTitle.text = nil
        }
        else if editingStyle == .insert {
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
class SomedayCustomCell : UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var checkMark: UIButton!
}
