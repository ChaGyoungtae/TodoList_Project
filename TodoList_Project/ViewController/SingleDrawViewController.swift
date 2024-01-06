//
//  SingleDrawViewController.swift
//  TodoList_Project
//
//  Created by cys on 2023/05/12.
//

import UIKit
import Firebase

class SingleDrawViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    var list = ""
    var inventory : [String] = []
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        singleDraw()
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
    //아직 기본 부품만 있어서 확률 조정해놓았음
    func singleDraw(){
        var randNum = arc4random_uniform(100)+1//1~100사이의 난수
        // 67% 로 기본부품 중 1개
        if randNum >= 1 && randNum <= 66{
            name.textColor = .black
            if randNum <= 22 {
                self.imgView.image = UIImage(named: "CPU_기본")
                name.text = "CPU_기본"
            }
            else if randNum <= 44 {
                self.imgView.image = UIImage(named: "GPU_기본")
                name.text = "GPU_기본"
            }
            else {
                self.imgView.image = UIImage(named: "팬_기본")
                name.text = "팬_기본"
            }
        }
        // 33%로 고급부품 중 1개
        else if randNum >= 67 && randNum <= 100{
            name.textColor = .purple
            if randNum <= 75 {
                self.imgView.image = UIImage(named: "케이스_고급")
                name.text = "케이스_고급"
            }
            else if randNum <= 83 {
                self.imgView.image = UIImage(named: "CPU_고급")
                name.text = "CPU_고급"
            }
            else if randNum <= 91 {
                self.imgView.image = UIImage(named: "GPU_고급")
                name.text = "GPU_고급"
            }
            else {
                self.imgView.image = UIImage(named: "팬_고급")
                name.text = "팬_고급"
            }
        }
        list = name.text!
        self.inventory.append(list)
        loadInventory()
    }

    @IBAction func closeButton(_ sender: Any) {
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
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
