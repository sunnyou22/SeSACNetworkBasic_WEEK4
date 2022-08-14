//
//  ViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/27.
//

import UIKit

class ViewController: UIViewController, ViewPresentableProtocol {
    func configureView() {
        
    }
    
    var navigationTitleString: String {
        get {
            "대장님의 다마고치"
        }
        set {
            title = newValue
        }
    }
    
    var backgroundColor: UIColor = .blue
      
    func configureView(color: UIColor) {
        view.backgroundColor = .blue
    }
    
    func configureLabel() {
        
        navigationTitleString = "고래밥님의 다마고치"
        
        title = navigationTitleString
        view.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        UserDefaultHelper.shared.nickname = "고래밥"
        title = UserDefaultHelper.shared.nickname // 네비 닉네임 작성할때 좋음 값을 변경
        print(UserDefaultHelper.shared.age)
    }


}

