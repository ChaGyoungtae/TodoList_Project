//
//  MultiDrawViewController.swift
//  TodoList_Project
//
//  Created by cys on 2023/06/06.
//

import UIKit
import Firebase

class MultiDrawViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var image5: UIImageView!
    
    
    @IBOutlet weak var name1: UILabel!
    
    @IBOutlet weak var name2: UILabel!
    
    @IBOutlet weak var name3: UILabel!
    
    @IBOutlet weak var name4: UILabel!
    
    @IBOutlet weak var name5: UILabel!
    
    var id = ""
    var inventory : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        five_Times_Draw()
        // Do any additional setup after loading the view.
    }
    
    func loadInventory() {
        let inventoryref = Database.database().reference(withPath: "\(self.id)/game/inventory")
        inventoryref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let part = snapshot.value as? String {
                    self.inventory.append(part)
                }
            }
            self.inventory = self.inventory.uniqued()
            self.inventory.sort()
            print(self.inventory)
            inventoryref.setValue(self.inventory)
        })
    }
    
    func five_Times_Draw(){
        
        for i in 0...4 {
            multiDraw()
            switch (i) {
            case 0:
                if(commonORepic(s: inventory[i]) == 1){
                    name1.textColor = .black
                }
                else {
                    name1.textColor = UIColor(named: "Purple")
                }
            case 1:
                if(commonORepic(s: inventory[i]) == 1){
                    name2.textColor = .black
                }
                else {
                    name2.textColor = UIColor(named: "Purple")
                }
            case 2:
                if(commonORepic(s: inventory[i]) == 1){
                    name3.textColor = .black
                }
                else {
                    name3.textColor = UIColor(named: "Purple")
                }
            case 3:
                if(commonORepic(s: inventory[i]) == 1){
                    name4.textColor = .black
                }
                else {
                    name4.textColor = UIColor(named: "Purple")
                }
            case 4:
                if(commonORepic(s: inventory[i]) == 1){
                    name5.textColor = .black
                }
                else {
                    name5.textColor = UIColor(named: "Purple")
                }
            default:
                break
            }

        }
        self.image1.image = UIImage(named: inventory[0])
        name1.text = inventory[0]
        
        self.image2.image = UIImage(named: inventory[1])
        
        name2.text = inventory[1]
        self.image3.image = UIImage(named: inventory[2])
        name3.text = inventory[2]
        self.image4.image = UIImage(named: inventory[3])
        name4.text = inventory[3]
        self.image5.image = UIImage(named: inventory[4])
        name5.text = inventory[4]
        loadInventory()
    }
    //기본부품인지 고급부품인지
    func commonORepic(s: String) -> Int {
        let part : [String] = s.components(separatedBy: "_")
        if(part[1] == "기본"){
            return 1
        }
        else {
            return 2
        }
    }
    
    func multiDraw() {
        let randNum = arc4random_uniform(100)+1//1~100사이의 난수
        // 67% 로 기본부품 중 1개
        if randNum >= 1 && randNum <= 66{
            if randNum <= 22 {
                inventory.append("CPU_기본")
            }
            else if randNum <= 44 {
                inventory.append("GPU_기본")
            }
            else {
                inventory.append("팬_기본")
            }
        }
        // 33%로 고급부품 중 1개
        else if randNum >= 67 && randNum <= 100{
            if randNum <= 75 {
                inventory.append("케이스_고급")
            }
            else if randNum <= 83 {
                inventory.append("CPU_고급")
            }
            else if randNum <= 91 {
                inventory.append("GPU_고급")
            }
            else {
                inventory.append("팬_고급")
            }
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
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

