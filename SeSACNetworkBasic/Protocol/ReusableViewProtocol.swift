//
//  ReusableViewProtocol.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/08/01.
//

import Foundation
import UIKit

protocol ReusableViweProtocol {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableViweProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViweProtocol {
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViweProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
