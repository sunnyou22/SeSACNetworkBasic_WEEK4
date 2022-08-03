//
//  ImageViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var cellCount = 30 // 셀 수 통일
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Delegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //MARK: 셀 가져오기
        self.collectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        //MARK: layout
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let sectionInset: CGFloat = 4
        let width = UIScreen.main.bounds.width - (spacing * 2 + sectionInset * 2)
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
    }
}

//MARK: - 프로토콜 채택
extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: 셀 총 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    //MARK: 셀 UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.fetchImage(index: indexPath, cellCount: cellCount)
        
        return cell
    }
}
