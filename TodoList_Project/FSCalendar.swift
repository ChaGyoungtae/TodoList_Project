//
//  FSCalendar.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/03/31.
//

import UIKit

class FSCalendar: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func Calendar(){
        let preVC = self.presentingViewController
        guard let vc = preVC as? CalenderViewController else { return }
        vc.FSCalendar.scope = .month
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
