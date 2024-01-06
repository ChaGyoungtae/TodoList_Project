//
//  InventoryViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/06/03.
//

import UIKit
import Firebase

class InventoryViewController: UIViewController {
    
    var list = ["케이스_기본"]
    var list_Case : [String] = []
    var list_CPU : [String] = []
    var list_GPU : [String] = []
    var list_Fan : [String] = []
    
    var id = ""
    var pcName = ""
    var row = 0
    
    //0 : ALL , 1 : Case , 2 : CPU , 3 : GPU , 4 : FAN
    var kategorie = 0
    
    
    var myCostomPC : [[String]] = []
    
    class customPC {
        
        var pc_Case = ""
        var CPU = ""
        var GPU = ""
        var fan = ""
        
        init() {
            self.pc_Case = "케이스_기본"
            self.CPU = "CPU_없음"
            self.GPU = "GPU_없음"
            self.fan = "팬_없음"
        }
        
        init(pc_Case: String = "", CPU: String = "", GPU: String = "", fan: String = "") {
            self.pc_Case = pc_Case
            self.CPU = CPU
            self.GPU = GPU
            self.fan = fan
        }
        
    }
    var PC = customPC()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    //배경색
    @IBOutlet weak var backGroundView: UIImageView!
    
    
    @IBOutlet weak var image_3D: UIImageView!
    
    
    @IBOutlet weak var inputPCName: UITextField!
    
    
    @IBOutlet weak var storeORmodify: UIButton!
    
    @IBOutlet weak var newORcancel: UIButton!
    
    @IBOutlet weak var notNullTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.sendSubviewToBack(self.backGroundView)
        self.storeORmodify.setTitle("저장하기", for: .normal)
        self.newORcancel.setTitle("new", for: .normal)
        self.notNullTitle.isHidden = true
        self.image_3D.image = UIImage(named:"3D_\(PC.pc_Case),\(PC.CPU),\(PC.GPU),\(PC.fan)")
        //pickerview 처음 선택된거
        self.loadInventory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.inputPCName.text = ""
    }
    
    @IBAction func goGame(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    //뽑은 부품들 불러오기
    func loadInventory() {
        let inventoryref = Database.database().reference(withPath: "\(self.id)/game/inventory")
        inventoryref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let part = snapshot.value as? String {
                    self.list.append(part)
                }
            }
            self.list = self.list.uniqued()
            self.list.sort()
            inventoryref.setValue(self.list)
            
            for i in 0..<self.list.count {
                let part : [String] = self.list[i].components(separatedBy: "_")
                if(part[0] == "케이스"){
                    self.list_Case.append(self.list[i])
                }
                else if (part[0] == "CPU") {
                    self.list_CPU.append(self.list[i])
                }
                else if (part[0] == "GPU") {
                    self.list_GPU.append(self.list[i])
                }
                else if (part[0] == "팬") {
                    self.list_Fan.append(self.list[i])
                }
            }
            self.collectionView.reloadData()
        })
        let galleryref = Database.database().reference(withPath: "\(self.id)/game/gallery")
        galleryref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let part = snapshot.value as? [String] {
                    self.myCostomPC.append(part)
                }
            }
            self.pickerView.reloadAllComponents()
            
            if( self.myCostomPC.count == 0) {
                let str = "3D_케이스_기본,CPU_없음,GPU_없음,팬_없음"
                self.splitPart(s: str)
            }
            else {
                self.image_3D.image = UIImage(named: self.myCostomPC[0][1])
                self.inputPCName.text = self.myCostomPC[0][0]
                self.splitPart(s: self.myCostomPC[0][1])
            }
        })
    }
    
    @IBAction func addNewPC(_ sender: Any) {
        var exp_check = 0
        let galleryref = Database.database().reference(withPath: "\(self.id)/game/gallery")
        let imgAdd = UIAlertController(title: "새로운 PC 만들기", message: "PC이름", preferredStyle: UIAlertController.Style.alert)
        imgAdd.addTextField{(myTextField) in
            myTextField.borderStyle = .line
            myTextField.borderColor = .black
            myTextField.text = "내 PC01"
        }
        let checkAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default,
                                        handler: {(action: UIAlertAction) -> Void in
            if let title = imgAdd.textFields?[0].text {
                
                for i in 0..<self.myCostomPC.count {
                    if(title == self.myCostomPC[i][0]){
                        exp_check = 1
                        let exception = UIAlertController(title: "오류", message: "이미 있는 이름입니다.", preferredStyle: UIAlertController.Style.alert)
                        let check = UIAlertAction(title: "확인", style: UIAlertAction.Style.default,
                                                  handler: nil)
                        exception.addAction(check)
                        self.present(exception, animated: true, completion: nil)
                    }
                }
                if(exp_check == 0){
                    self.myCostomPC.append([title,"3D_케이스_기본,CPU_없음,GPU_없음,팬_없음"])
                    self.inputPCName.text = title
                    galleryref.setValue(self.myCostomPC)
                    self.collectionView.reloadData()
                    self.pickerView.reloadAllComponents()
                }
            }
        
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        imgAdd.addAction(checkAction)
        imgAdd.addAction(cancelAction)
        
        present(imgAdd, animated: true, completion: nil)
    }

    @IBAction func closeButton(_ sender: UIButton) {
        //guard let goCalender = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalenderViewController else {return}
        
        //부품 조립 뷰에서 캘린더로 갈때도 포인트 전달되어야함
        self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
            if let aViewController = self.presentingViewController as? SideMenuViewController {
                aViewController.viewWillAppear(true)
            }
        }
        
        
        
        //dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func set_3Dview() {

        let CPU = PC.CPU
        let GPU = PC.GPU
        let pc_case = PC.pc_Case
        let fan = PC.fan
        self.image_3D.image = UIImage(named:"3D_\(pc_case),\(CPU),\(GPU),\(fan)")

    }
    
    func splitPart(s : String) {
        let str = s.suffix(25)
        let part = str.components(separatedBy: ",")
    
        self.PC.pc_Case = part[0]
        self.PC.CPU = part[1]
        self.PC.GPU = part[2]
        self.PC.fan = part[3]
    }
    
    
    @IBAction func storePC(_ sender: Any) {
        var a = 0
        let galleryref = Database.database().reference(withPath: "\(self.id)/game/gallery")
        if(self.inputPCName.text == ""){
            notNullTitle.isHidden = false
        }
        else {
            let imgLoad = UIAlertController(title: "이미지 덮어쓰기", message: "이미지를 덮어쓰시겠습니까?\n(주의 : 되돌릴 수 없습니다.)", preferredStyle: UIAlertController.Style.alert)
            let checkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default,
                                            handler: {(action: UIAlertAction) -> Void in
                
                var str = [String]()
                let ref1 = Database.database().reference(withPath: "\(self.id)/game/myPC")
                ref1.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                           let myPC = snapshot.value as? String {
                            str.append(myPC)
                        }
                    }
                    if(str.count > 0){
                        if(str[0] == self.myCostomPC[self.row][0]){
                            self.myCostomPC[self.row][1] = "3D_\(self.PC.pc_Case),\(self.PC.CPU),\(self.PC.GPU),\(self.PC.fan)"
                            self.myCostomPC[self.row][0] = self.inputPCName.text!
                            galleryref.setValue(self.myCostomPC)
                            ref1.setValue(self.myCostomPC[self.row])
                        }
                        else {
                            self.myCostomPC[self.row][1] = "3D_\(self.PC.pc_Case),\(self.PC.CPU),\(self.PC.GPU),\(self.PC.fan)"
                            self.myCostomPC[self.row][0] = self.inputPCName.text!
                            galleryref.setValue(self.myCostomPC)
                        }
                    }
                    else {
                        self.myCostomPC[self.row][1] = "3D_\(self.PC.pc_Case),\(self.PC.CPU),\(self.PC.GPU),\(self.PC.fan)"
                        self.myCostomPC[self.row][0] = self.inputPCName.text!
                        galleryref.setValue(self.myCostomPC)
                    }
                    self.notNullTitle.isHidden = true
                    self.collectionView.reloadData()
                    self.pickerView.reloadAllComponents()
                })
                

            })
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) -> Void in
                self.inputPCName.text! = self.myCostomPC[self.row][0]
            })
            imgLoad.addAction(checkAction)
            imgLoad.addAction(cancelAction)

            present(imgLoad, animated: true, completion: nil)
        }
    }
    
    @IBAction func goGallery(_ sender: Any) {
        guard let goGallery = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as? GalleryViewController else {return}
        
        goGallery.modalPresentationStyle = .fullScreen
        goGallery.id = self.id
        
        guard let pvc = self.presentingViewController else {return}
        
        self.dismiss(animated: false){
            pvc.present(goGallery, animated: true)
        }
        
    }
    
    
    //선택한 부품만 보이기
    @IBAction func showAll(_ sender: Any) {
        self.kategorie = 0
        self.collectionView.reloadData()
    }
    @IBAction func showCase(_ sender: Any) {
        self.kategorie = 1
        self.collectionView.reloadData()
    }
    @IBAction func showCPU(_ sender: Any) {
        self.kategorie = 2
        self.collectionView.reloadData()
    }
    @IBAction func showGPU(_ sender: Any) {
        self.kategorie = 3
        self.collectionView.reloadData()
    }
    @IBAction func showFan(_ sender: Any) {
        self.kategorie = 4
        self.collectionView.reloadData()
    }
    
    
    
    
    
}

//cell에 관한 delegate
extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if(self.kategorie == 0) {
            return list.count
        }
        else if(self.kategorie == 1) {
            return list_Case.count
        }
        else if(self.kategorie == 2) {
            return list_CPU.count
        }
        else if(self.kategorie == 3) {
            return list_GPU.count
        }
        else {
            return list_Fan.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell

        
        if(self.kategorie == 0) {
            if(list[indexPath.row] != ""){
                cell.imgView.image = UIImage(named: list[indexPath.row]) ?? UIImage()
            }
        }
        else if(self.kategorie == 1) {
            if(list_Case[indexPath.row] != ""){
                cell.imgView.image = UIImage(named: list_Case[indexPath.row]) ?? UIImage()
            }
        }
        else if(self.kategorie == 2) {
            if(list_CPU[indexPath.row] != ""){
                cell.imgView.image = UIImage(named: list_CPU[indexPath.row]) ?? UIImage()
            }
        }
        else if(self.kategorie == 3) {
            if(list_GPU[indexPath.row] != ""){
                cell.imgView.image = UIImage(named: list_GPU[indexPath.row]) ?? UIImage()
            }
        }
        else if(self.kategorie == 4) {
            if(list_Fan[indexPath.row] != ""){
                cell.imgView.image = UIImage(named: list_Fan[indexPath.row]) ?? UIImage()
            }
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //선택한 이미지의 이름을 _ 로 나누어서 customPC에 멤버에 맞게 집어넣고 그에 맞는 3d이미지 띄우기
        var part : [String] = []
        var arr  : [String] = []
        if(self.kategorie == 0) {
            arr = list
        }
        else if(self.kategorie == 1) {
            arr = list_Case
        }
        else if(self.kategorie == 2) {
            arr = list_CPU
        }
        else if(self.kategorie == 3) {
            arr = list_GPU
        }
        else if(self.kategorie == 4) {
            arr = list_Fan
        }
        part = arr[indexPath.row].components(separatedBy: "_")
        if(part[0] == "GPU") {
            if(PC.GPU == arr[indexPath.row]){
                PC.GPU = "GPU_없음"
            }
            else {
                PC.GPU = arr[indexPath.row]
            }
        }
        else if (part[0] == "CPU") {
            if(PC.CPU == arr[indexPath.row]){
                PC.CPU = "CPU_없음"
            }
            else {
                PC.CPU = arr[indexPath.row]
            }
        }
        else if (part[0] == "케이스") {
            if(PC.pc_Case != arr[indexPath.row]){
                PC.pc_Case = arr[indexPath.row]
            }
        }
        else if (part[0] == "팬") {
            if(PC.fan == arr[indexPath.row]){
                PC.fan = "팬_없음"
            }
            else {
                PC.fan = arr[indexPath.row]
            }
        }
        self.set_3Dview()
    }
    
}

//cell layout
extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    
    //위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell 배치
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //세로 2등분 하여 배치
        let height = collectionView.frame.height / 2 - 1
        //가로 3등분 하여 배치
        let width = collectionView.frame.width / 3 - 1
        
        let size = CGSize(width: width, height: height)
        return size
    }
}
extension InventoryViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.myCostomPC.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.myCostomPC[row][0]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(self.myCostomPC.count == 0){
            
        }
        else {
            self.image_3D.image = UIImage(named: self.myCostomPC[row][1])
            splitPart(s: self.myCostomPC[row][1])
            self.inputPCName.text = self.myCostomPC[row][0]
            self.row = row
        }
    }
    

}
class CSCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    
}

