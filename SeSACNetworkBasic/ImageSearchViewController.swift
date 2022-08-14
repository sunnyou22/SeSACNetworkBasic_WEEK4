//
//  ImageViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ImageSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var list: [String] = []
    var startPage = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Delegate
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self // 페이지 네이션
        
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
    
    func fetchImage(query: String) {
        ImageSearchAPIManager.shared.fetchImageData(query: query, startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.list.append(contentsOf: list)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //페이지네이션 방법1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    //마지막 셀에 사용자가 위치해있는 지 명확하게 확인하기가 어려움
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        <#code#>
    //    }
    
    //페이지네이션 방법2. UIScrollViewDelegateProtocol
    // 테이블뷰/컬렉션뷰 스크롤뷰 상속받고 잇어서 스크롤 뷰 프로토콜을 사용할 수 있음
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print(scrollView.contentOffset)
    //    }
}

//MARK: - 프로토콜 채택

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
            fetchImage(query: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        list.removeAll()
        collectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        searchBar.setShowsCancelButton((true), animated: true)
    }
}



// 페이지네이션 방법3/
//용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적.
//셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수도 있고, 필요하지 않다면 데이터를 취소할 수도 있음
//ios.10이상, 스크롤 성능 향상됨

//셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 30
                fetchImage(query: searchBar.text!)
            }
        }
        print("=====\(indexPaths)=============")
    }
    
    //사용자가 엄청 빨리 스크롤링하면 다운받지 않아도됨
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)")
    }
}



extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: 셀 총 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    //MARK: 셀 UI
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let url = URL(string: list[indexPath.row])
        cell.imageCell.kf.setImage(with: url)
        cell.contentMode = .scaleToFill
        return cell
    }
}
