//
//  GalleryViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/06/10.
//

import UIKit
import Firebase

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var selectPC: UILabel!
    
    
    @IBOutlet weak var btnMyPC: UIButton!
    
    var id = ""
    var myCostomPC : [[String]] = [["!0","none"]]
    var pcName = ""
    var currentLongPressedCell : IndexPath?
    
    var saveMyPc = ["",""]
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupLongGestureRecognizerOnCollection()
        print(myCostomPC.count)
        imgView.image = UIImage(named: "none")
        loadGallery()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePC(_ sender: Any) {
        
        let OKalert = UIAlertController(title: "내PC로 지정", message: "등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let checkAction2 = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        OKalert.addAction(checkAction2)
        if(self.selectPC.text == "") {
            let samePC = UIAlertController(title: "오류", message: "PC를 선택해주세요.", preferredStyle: UIAlertController.Style.alert)
            let checkAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            samePC.addAction(checkAction)
            self.present(samePC, animated: true, completion: nil)
        }
        else {
            self.ref = Database.database().reference()
                    var str = [String?]()
                    let ref1 = Database.database().reference(withPath: "\(self.id)/game/myPC")
                    ref1.observeSingleEvent(of: .value, with: { snapshot in
                        for child in snapshot.children {
                            if let snapshot = child as? DataSnapshot,
                               let myPC = snapshot.value as? String {
                                str.append(myPC)
                            }
                        }
                        if (str.count == 0){
                            let myPC = self.ref.child("\(self.id)/game/myPC")
                            myPC.setValue(self.saveMyPc)
                            self.present(OKalert, animated: true, completion: nil)
                        }
                        else {
                            if (self.selectPC.text != str[0]!) {
                                let myPC = self.ref.child("\(self.id)/game/myPC")
                                myPC.setValue(self.saveMyPc)
                                self.present(OKalert, animated: true, completion: nil)
                            }
                            else{
                                let samePC = UIAlertController(title: "중복", message: "이미 동일한 PC가 저장되어 있습니다.", preferredStyle: UIAlertController.Style.alert)
                                let checkAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                                samePC.addAction(checkAction)
                                self.present(samePC, animated: true, completion: nil)
                            }
                        }
                    })
        }
    }
    
    func checkArraysEqual(str1: String, str2: String) -> Bool { //4번
           // 배열의 길이가 다르면 동일하지 않으므로 false 반환
        
        if(str2.count == 0){
            return true
        }
        
           guard str1.count == str2.count else {
               return false
           }

           // 모든 요소가 동일하면 true 반환
           return true
       }

    
    func loadGallery(){
        self.myCostomPC.removeAll()
        let galleryref = Database.database().reference(withPath: "\(self.id)/game/gallery")
        galleryref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let part = snapshot.value as? [String] {
                    self.myCostomPC.append(part)
                }
            }
            print(self.myCostomPC)
            self.collectionView.reloadData()
            var str = [String]()
            let ref1 = Database.database().reference(withPath: "\(self.id)/game/myPC")
            ref1.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let myPC = snapshot.value as? String {
                        str.append(myPC)
                    }
                }
                if(str.count != 0){
                    self.selectPC.text = str[0]
                    self.imgView.image = UIImage(named: str[1])
                }
                else {
                    self.selectPC.text = ""
                    self.imgView.image = UIImage()
                }
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

    @IBAction func goInventory(_ sender: Any) {
        guard let goInventory = self.storyboard?.instantiateViewController(identifier: "InventoryViewController") as? InventoryViewController else {return}
        
        goInventory.modalPresentationStyle = .fullScreen
        goInventory.id = self.id
        
        guard let pvc = self.presentingViewController else {return}
        
        self.dismiss(animated: false){
            pvc.present(goInventory, animated: true)
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
            if let aViewController = self.presentingViewController as? SideMenuViewController {
                aViewController.viewWillAppear(true)
            }
        }
    }
    
    @IBAction func goGame(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    

}
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myCostomPC.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.img.image = UIImage(named:myCostomPC[indexPath.row][1]) ?? UIImage()
        cell.imgName.text = myCostomPC[indexPath.row][0]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        saveMyPc[0] = myCostomPC[indexPath.row][0]
        saveMyPc[1] = myCostomPC[indexPath.row][1]

        self.imgView.image = UIImage(named:myCostomPC[indexPath.row][1]) ?? UIImage()
        self.selectPC.text = myCostomPC[indexPath.row][0]
    
        self.pcName = myCostomPC[indexPath.row][0]
    }
}
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
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
extension GalleryViewController: UIGestureRecognizerDelegate {
    
    //long press 이벤트 부여
    private func setupLongGestureRecognizerOnCollection() {
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in:collectionView)
        
        if gestureRecognizer.state == .began {
            
            if let indexPath = collectionView.indexPathForItem(at: location){
                self.currentLongPressedCell = indexPath
            }
        }
        else if gestureRecognizer.state == .ended {
            if let indexPath = collectionView.indexPathForItem(at: location){
                if indexPath == self.currentLongPressedCell {
                 
                    //이미지 길게 누를 시 삭제하겠냐는 메세지
                    let imgDelete = UIAlertController(title: "이미지 삭제", message: "삭제하시겠습니까?\n(주의 : 되돌릴 수 없습니다.)", preferredStyle: UIAlertController.Style.alert)
                    let checkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default,
                                                    handler: {(action: UIAlertAction) -> Void in
                        self.deleteImg(idx: indexPath)
                    })
                    let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
                    imgDelete.addAction(checkAction)
                    imgDelete.addAction(cancelAction)
                    
                    present(imgDelete, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func deleteImg(idx: IndexPath){
        var str = [String]()
        let ref1 = Database.database().reference(withPath: "\(self.id)/game/myPC")
        ref1.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let myPC = snapshot.value as? String {
                    str.append(myPC)
                }
            }
            if(str[0] == self.myCostomPC[idx.row][0]){
                ref1.setValue(["",""])
            }
            if(self.selectPC.text == self.myCostomPC[idx.row][0]) {
                self.selectPC.text = ""
                self.imgView.image = UIImage()
            }
            self.myCostomPC.remove(at:[idx.row][0])
            let galleryref = Database.database().reference(withPath: "\(self.id)/game/gallery")
            galleryref.setValue(self.myCostomPC)
            self.collectionView.reloadData()
        })
    }
}
class GalleryCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var imgName: UILabel!
    
}
