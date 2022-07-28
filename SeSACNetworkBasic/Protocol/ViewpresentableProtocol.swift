//
//  ViewpresentableProtocol.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/28.
//

import Foundation
import UIKit

@objc
protocol ViewPresentableProtocol {
    var navigationTitleString: String { get set }
    var backgroundColor: UIColor { get }
    
    func configureView()
    func configureLabel()
   @objc optional func configureTextField()
}

@objc
protocol SunTableViewProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
   @objc optional func didSlectRowAt()
}

