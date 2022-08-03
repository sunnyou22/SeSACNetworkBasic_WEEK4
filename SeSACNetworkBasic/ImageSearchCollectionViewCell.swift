//
//  ImageSearchCollectionViewCell.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ImageSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    
//    var list: [URL] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fetchImage(index: IndexPath, cellCount: Int) {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 이걸 해주면 인썸니아처럼 UTF-8로 바꿔쥼, 옵셔널임 그래서 처리해쥬기
        let url = EndPoint.imageSearchURL + "query=\(text)&display=\(cellCount)&start=1" // 값만 맞으면돼서 순서는 상관없음. 30개보여주고 31번부터 30개 보여줌
        let header: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.NAVERID, "X-Naver-Client-Secret" : APIKey.NAVERSCRETKEY]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let imageurl = URL(string: json["items"][index.row]["link"].stringValue)
                self.imageCell.kf.setImage(with: imageurl)
                self.imageCell.contentMode = .scaleToFill
                print("JSON: \(json)")
                
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
