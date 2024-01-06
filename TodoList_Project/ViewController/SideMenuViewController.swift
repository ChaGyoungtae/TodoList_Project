//
//  SideMenuViewController.swift
//  TodoList_Project
//
//  Created by cys on 2023/04/02.
//

import UIKit
import FirebaseAuth

class SideMenuViewController: UIViewController {

    var id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Calender뷰 메서드 접근
        if let aViewController = self.presentingViewController as? CalenderViewController {
            aViewController.viewWillAppear(true)
        }
    }
    
    // 사이드 메뉴 닫기
    @IBAction func CloseMenuButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        try? Auth.auth().signOut()
            }
    
    @IBAction func goGame(_ sender: Any) {
        guard let goGame = self.storyboard?.instantiateViewController(identifier: "Game_MainViewController") as? Game_MainViewController else {return}
        
        goGame.id = self.id
        goGame.modalPresentationStyle = .fullScreen
        present(goGame, animated: true)
        
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
