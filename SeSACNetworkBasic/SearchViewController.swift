//
//  SearchViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD

//1. 왼팔/오른팔
//2. 테이블뷰 아웃렛 연결
//3. 1 + 2

/*
 struct BoxOfficeModel {
 
 let movieTitle: String
 let releaseDate: String
 let totalCount: String
 
 }
 */


class SearchViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var list: [BoxOfficeModel] = []
    var hud = JGProgressHUD()
    
    func configureLabel() {
        
    }
    
    var navigationTitleString: String = ""
    var backgroundColor: UIColor = .blue
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         swift protocol -> 왼팔과 오른팔이 속하는 곳
         - Delegate
         - Datasource
         */
        
        //MARK: 연결고리 작업:
        //테이블뷰가 해야할역할을 뷰 컨트롤러에게 위임하는 것 이게 없으면 테이블뷰 따로 뷰컨따로라서 연결되지 않음 : 딜리케이트 패턴
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        
        //MARK: 테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        //XIB: xml Interface Builder 옛날에는 nib이라는 이름을 사용했었음
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        //네트워크 통신: 서버 저검 등에 대한 예외 처리
        //네트워
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    //MARK: - API 요청함수
    func requestBoxOffice(text: String) {
        hud.show(in: view)
        self.list.removeAll()
        
        let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "ko_KR")
           formatter.dateFormat = "yyyyMMdd"
        
        // 이렇게 코드 작성했을대 nil이 나올 수 있는 부분 생각하기 / 지정된 형식의 문자가 들어오지 않았을 때 조건처리해주기, 매개변수 기본값이랑 중복되는 느낌
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: ((searchBar.text?.isEmpty ?? true ? Date() : formatter.date(from: text)!)))
        let countDay = formatter.string(from: yesterday!)
   
         // 데이터가 쌓이게 UI를 표현하지 않기 위해서는 해줘야함 removeAll()을 한다고 빨라지진 않음
        
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(countDay)"
        
        AF.request(url, method: .get).validate().responseData { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print("JSON: \(json)")
                //            self.list.removeAll()
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                    
                    self.list.append(data)
                }
                
                //
                //            let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
                //            let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
                //            let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
                //
                //            self.list.append(movieNm1)
                //            self.list.append(movieNm2)
                //            self.list.append(movieNm3)
                
                //테이블뷰 갱식
                self.searchTableView.reloadData()
                self.hud.dismiss(afterDelay: 1)
            case .failure(let error):
                print(error)
                
                self.hud.dismiss(afterDelay: 3)
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
        
    }
    
    // 이건 셀을 디자인하는 겅
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() } // 내부매개변수로 선언돼설 사용할 수 있음 프로토콜을 채택해야 함수를 불러올 수 있고 불러온 함수의 매개변수를 사용한거임. 왼팔오른팔로 사용할 수 있는게 아님 -> 결국 어떤 테이블뷰에 보여주고싶은지 결정하려면 아웃렛 연결
        
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle) : \(list[indexPath.row].releaseDate)"
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!)
    }
}


extension UIViewController {
    
    func setBackgroundColor() {
        view.backgroundColor = .red // -> 이렇게 한번에 설정할 수 있음
    }
    
}

struct BoxofficeDateFormat {
    static let formatter = DateFormatter()
    
    static func setFormatter() -> DateFormatter {
        UserDateFormat.formatter.locale = Locale(identifier: "ko_KR")
        UserDateFormat.formatter.dateFormat = "yyyyMMdd"
        
        return UserDateFormat.formatter
    }
}



