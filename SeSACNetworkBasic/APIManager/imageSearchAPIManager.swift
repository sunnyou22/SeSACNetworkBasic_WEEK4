//
//  imageSearchAPIManager.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON
//싱글턴패턴을 보통 클래스로만 만든다
class ImageSearchAPIManager {
    // 상속을 받아서 해결하는 건 좋지 않음
    static let shared = ImageSearchAPIManager()
    
    private init() {}
    
    typealias completionHandler = (Int, [String]) -> Void
    
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping completionHandler) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 이걸 해주면 인썸니아처럼 UTF-8로 바꿔쥼, 옵셔널임 그래서 처리해쥬기
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)" // 값만 맞으면돼서 순서는 상관없음. 30개보여주고 31번부터 30개 보여줌
        let header: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.NAVERID, "X-Naver-Client-Secret" : APIKey.NAVERSCRETKEY]
        
        // 큐를 글로벌로 바꿔서 컬렉션뷰 리로드는 메인에서 해야함
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let totalCount = json["total"].intValue
                
                // 이 부분 다시
                let list = json["items"].arrayValue.map { $0["link"].stringValue }
              
                
              completionHandler(totalCount, list) //처리된 데이터를 클로져구문으로 전달해줌
                
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}
