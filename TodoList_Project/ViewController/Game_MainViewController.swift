//
//  Game_MainViewController.swift
//  TodoList_Project
//
//  Created by cys on 2023/05/12.
//

import UIKit
import Firebase

class Game_MainViewController: UIViewController {

    
    @IBOutlet weak var main_image: UIImageView!
    
    @IBOutlet weak var point: UILabel!
    
    @IBOutlet weak var backGroundView: UIImageView!
    var id = ""
    
    var ref : DatabaseReference!
    
    var parampart : String?
    var inventory : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.backGroundView)
        self.main_image.image = UIImage(named: "main_illust")
        self.main_image.layer.cornerRadius = 25
        self.loadPoint()
        // Do any additional setup after loading the view.
        

    }
    
    func loadPoint() {
        let ref = Database.database().reference(withPath: "\(self.id)/point")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? String ?? ""
            self.point.text = value
        })
    }
    
    @IBAction func draw_Single(_ sender: Any) {
        
        let text = self.point.text!
        var pt : Int = Int(text)!
        
        //포인트가 10포인트 미만이면 뽑기 실행 못함
        if pt >= 10{
            pt -= 10
            
            var ref = Database.database().reference()
            let pointRef = ref.child("\(self.id)/point")
            pointRef.setValue(String(pt))
            loadPoint()
            
            guard let godraw_Single = self.storyboard?.instantiateViewController(identifier: "SingleDrawViewController") as? SingleDrawViewController else {return}
            godraw_Single.id = self.id
            present(godraw_Single, animated: true)
        }
        else{
            let noPoints = UIAlertController(title: "알림", message: "포인트가 부족합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            noPoints.addAction(cancelAction)
            
            present(noPoints, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func multi_draw(_ sender: Any) {
        let text = self.point.text!
        var pt : Int = Int(text)!
        
        //포인트가 10포인트 미만이면 뽑기 실행 못함
        if pt >= 50{
            pt -= 50
            
            var ref = Database.database().reference()
            let pointRef = ref.child("\(self.id)/point")
            pointRef.setValue(String(pt))
            loadPoint()
            
            guard let godraw_Multi = self.storyboard?.instantiateViewController(identifier: "MultiDrawViewController") as? MultiDrawViewController else {return}
            godraw_Multi.id = self.id
            present(godraw_Multi, animated: true)
            
        }
        else{
            let noPoints = UIAlertController(title: "알림", message: "포인트가 부족합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            noPoints.addAction(cancelAction)
            
            present(noPoints, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        //guard let goCalender = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as? CalenderViewController else {return}
        
        // side메뉴 뷰의 메서드 접근
        dismiss(animated: true) {
            if let aViewController = self.presentingViewController as? SideMenuViewController {
                aViewController.viewWillAppear(true)
            }
        }


        
        
        
        //dismiss(animated: true, completion: nil)
    }
    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    

    
    
    @IBAction func goInventory(_ sender: Any) {
        guard let goInventory = self.storyboard?.instantiateViewController(identifier: "InventoryViewController") as? InventoryViewController else {return}
        
        goInventory.modalPresentationStyle = .fullScreen
        goInventory.id = self.id
        present(goInventory, animated: true)
    }
    
    @IBAction func goGallery(_ sender: Any) {
        guard let goGallery = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as? GalleryViewController else {return}
        
        goGallery.modalPresentationStyle = .fullScreen
        goGallery.id = self.id
        present(goGallery, animated: true)
    }
    
    
    
}
