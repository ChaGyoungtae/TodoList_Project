//
//  Add2ViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/04/11.
//

import UIKit

class Add2ViewController: UIViewController {

    @IBOutlet weak var inputTitle: UITextField!
    

    @IBOutlet weak var selectedDate: UILabel!
    var currentdate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate.text = currentdate
        
        // Do any additional setup after loading the view.
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
