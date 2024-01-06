//
//  CustomSideMenuNavigation.swift
//  TodoList_Project
//
//  Created by cys on 2023/04/02.
//

import UIKit
import SideMenu

class CustomSideMenuNavigation: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //메뉴 나오는 스타일
        self.presentationStyle = .menuSlideIn
        //메뉴 왼쪽에서 나오기
        self.leftSide = true
        //상단 상태바 보이도록 설정 0 ( 0~1 default 1 )
        self.statusBarEndAlpha = 0.0
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
