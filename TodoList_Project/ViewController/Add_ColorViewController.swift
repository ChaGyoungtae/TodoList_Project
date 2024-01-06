//
//  Add_ColorViewController.swift
//  TodoList_Project
//
//  Created by 차경태 on 2023/04/11.
//

import UIKit

class Add_ColorViewController: UIViewController {
    
    let redColor = UIColor(named:"Red")
    let deepblueColor = UIColor(named:"Deep Blue")
    let greenColor = UIColor(named:"Green")
    let beigeColor = UIColor(named:"Beige")
    let orangeColor = UIColor(named:"Orange")
    let yellowColor = UIColor(named:"Yellow")
    let purpleColor = UIColor(named:"Purple")
    let pinkColor = UIColor(named:"Pink")
    var viewtype = ""
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var deepblueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var beigeButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    
    @IBOutlet weak var addColorView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(addColorView)
        
        redButton.backgroundColor = redColor
        redButton.layer.cornerRadius = 4
        
        deepblueButton.backgroundColor = deepblueColor
        deepblueButton.layer.cornerRadius = 4
        
        greenButton.backgroundColor = greenColor
        greenButton.layer.cornerRadius = 4
        
        beigeButton.backgroundColor = beigeColor
        beigeButton.layer.cornerRadius = 4
        
        orangeButton.backgroundColor = orangeColor
        orangeButton.layer.cornerRadius = 4
        
        yellowButton.backgroundColor = yellowColor
        yellowButton.layer.cornerRadius = 4
        
        purpleButton.backgroundColor = purpleColor
        purpleButton.layer.cornerRadius = 4
        
        pinkButton.backgroundColor = pinkColor
        pinkButton.layer.cornerRadius = 4
        
    }

    @IBAction func redButtonAction(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let redColor = UIColor(named: "Red") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let redComponents = redColor.cgColor.components
            vc.color.backgroundColor = redColor
            // redComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = redComponents?[0], let g = redComponents?[1], let b = redComponents?[2], let a = redComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let redColor = UIColor(named: "Red") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let redComponents = redColor.cgColor.components
            vc.chgColor.backgroundColor = redColor
            // redComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = redComponents?[0], let g = redComponents?[1], let b = redComponents?[2], let a = redComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
       
    }
    
    
    @IBAction func deepblueButton(_ sender: Any) {
        
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let deepblueColor = UIColor(named: "Deep Blue") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let deepblueComponents = deepblueColor.cgColor.components
            vc.color.backgroundColor = deepblueColor
            // deepblueComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = deepblueComponents?[0], let g = deepblueComponents?[1], let b = deepblueComponents?[2], let a = deepblueComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let deepblueColor = UIColor(named: "Deep Blue") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let deepblueComponents = deepblueColor.cgColor.components
            vc.chgColor.backgroundColor = deepblueColor
            // deepblueComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = deepblueComponents?[0], let g = deepblueComponents?[1], let b = deepblueComponents?[2], let a = deepblueComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }

    }
    
    @IBAction func greenButton(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let greenColor = UIColor(named: "Green") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let greenComponents = greenColor.cgColor.components
            vc.color.backgroundColor = greenColor
            // greenComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = greenComponents?[0], let g = greenComponents?[1], let b = greenComponents?[2], let a = greenComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let greenColor = UIColor(named: "Green") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let greenComponents = greenColor.cgColor.components
            vc.chgColor.backgroundColor = greenColor
            // greenComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = greenComponents?[0], let g = greenComponents?[1], let b = greenComponents?[2], let a = greenComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    @IBAction func beigeButton(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let beigeColor = UIColor(named: "Beige") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let beigeComponents = beigeColor.cgColor.components
            vc.color.backgroundColor = beigeColor
            // beigeComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = beigeComponents?[0], let g = beigeComponents?[1], let b = beigeComponents?[2], let a = beigeComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let beigeColor = UIColor(named: "Beige") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let beigeComponents = beigeColor.cgColor.components
            vc.chgColor.backgroundColor = beigeColor
            // beigeComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = beigeComponents?[0], let g = beigeComponents?[1], let b = beigeComponents?[2], let a = beigeComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    @IBAction func orangeButton(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let orangeColor = UIColor(named: "Orange") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let orangeComponents = orangeColor.cgColor.components
            vc.color.backgroundColor = orangeColor
            // orangeComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = orangeComponents?[0], let g = orangeComponents?[1], let b = orangeComponents?[2], let a = orangeComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let orangeColor = UIColor(named: "Orange") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let orangeComponents = orangeColor.cgColor.components
            vc.chgColor.backgroundColor = orangeColor
            // orangeComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = orangeComponents?[0], let g = orangeComponents?[1], let b = orangeComponents?[2], let a = orangeComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    @IBAction func yellowButton(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let yellowColor = UIColor(named: "Yellow") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let yellowComponents = yellowColor.cgColor.components
            vc.color.backgroundColor = yellowColor
            // yellowComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = yellowComponents?[0], let g = yellowComponents?[1], let b = yellowComponents?[2], let a = yellowComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let yellowColor = UIColor(named: "Yellow") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let yellowComponents = yellowColor.cgColor.components
            vc.chgColor.backgroundColor = yellowColor
            // yellowComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = yellowComponents?[0], let g = yellowComponents?[1], let b = yellowComponents?[2], let a = yellowComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    @IBAction func purpleButton(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let purpleColor = UIColor(named: "Purple") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let purpleComponents = purpleColor.cgColor.components
            vc.color.backgroundColor = purpleColor
            // purpleComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = purpleComponents?[0], let g = purpleComponents?[1], let b = purpleComponents?[2], let a = purpleComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let purpleColor = UIColor(named: "Purple") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let purpleComponents = purpleColor.cgColor.components
            vc.chgColor.backgroundColor = purpleColor
            // purpleComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = purpleComponents?[0], let g = purpleComponents?[1], let b = purpleComponents?[2], let a = purpleComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
       
    }
    
    @IBAction func pinkButton(_ sender: Any) {
        if viewtype == "T" {
            let preVC = self.presentingViewController
            guard let vc = preVC as? AddViewController else { return }
            
            guard let pinkColor = UIColor(named: "Pink") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let pinkComponents = pinkColor.cgColor.components
            vc.color.backgroundColor = pinkColor
            // pinkComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = pinkComponents?[0], let g = pinkComponents?[1], let b = pinkComponents?[2], let a = pinkComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.string = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
        if viewtype == "F"{
            let preVC = self.presentingViewController
            guard let vc = preVC as? ModifyViewController else { return }
            
            guard let pinkColor = UIColor(named: "Pink") else {
                // 적절한 색상을 가져오지 못한 경우
                return
            }
            
            // RGBA 값을 가져오기
            let pinkComponents = pinkColor.cgColor.components
            vc.chgColor.backgroundColor = pinkColor
            // pinkComponents 배열에서 각 색상 구성 요소를 추출하여 Float 값으로 변환
            guard let r = pinkComponents?[0], let g = pinkComponents?[1], let b = pinkComponents?[2], let a = pinkComponents?[3] else {
                // 구성 요소를 가져오지 못한 경우
                return
            }

            // RGBA 값을 문자열로 변환
            let rgbaString = String(format: "rgba(%.2f,%.2f,%.2f,%.2f)", r, g, b, a)

            // 문자열을 파이어베이스에 저장하거나 필요한 대로 사용
            
            vc.prepareColor = rgbaString
            self.presentingViewController?.dismiss(animated: true)
        }
    }
}
