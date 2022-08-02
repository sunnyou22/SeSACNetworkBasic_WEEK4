//
//  RecommendBeersViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/08/02.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class RecommendBeersViewController: UIViewController {
    @IBOutlet weak var beerTitle: UILabel!
    @IBOutlet weak var beer: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescrition: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beerTitle.text = "맥주를 마시고 싶다"
        beerTitle.font = .boldSystemFont(ofSize: 20)
        beerTitle.textAlignment = .center
        
        requestTranslatedData()
    }
    
    func requestTranslatedData() {
        let url = EndPoint.beerURL

        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let imageURL = URL(string: json[0]["image_url"].stringValue)
                
                print("JSON: \(json)")
                self.beer.text = json[0]["name"].stringValue
                self.beerImage.kf.setImage(with: imageURL)
                self.beerDescrition.text = json[0]["description"].stringValue
                
                
                let statusCode = response.response?.statusCode ?? 500 // 이렇게 statusCode를 해결할 수 있음
                
                if statusCode == 200 {
                    
                } else {
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }

}
