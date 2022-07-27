//
//  SearchViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/27.
//

import UIKit

//1. 왼팔/오른팔
//2. 테이블뷰 아웃렛 연결
//3. 1 + 2

extension UIViewController {
    
    func setBackgroundColor() {
        view.backgroundColor = .red // -> 이렇게 한번에 설정할 수 있음
    }
    
}


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
 swift protocol -> 왼팔과 오른팔이 속하는 곳
 - Delegate
 - Datasource
 */
        
        //연결고리 작업: 테이블뷰가 해야할역할을 뷰 컨트롤러에게 위임하는 것 이게 없으면 테이블뷰 따로 뷰컨따로라서 연결되지 않음 : 딜리케이트 패턴
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        //XIB: xml Interface Builder 옛날에는 nib이라는 이름을 사용했었음
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    // 이건 셀을 디자인하는 겅
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() } // 내부매개변수로 선언돼설 사용할 수 있음 프로토콜을 채택해야 함수를 불러올 수 있고 불러온 함수의 매개변수를 사용한거임. 왼팔오른팔로 사용할 수 있는게 아님 -> 결국 어떤 테이블뷰에 보여주고싶은지 결정하려면 아웃렛 연결
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "Hello"
        
        return cell
    }
}
