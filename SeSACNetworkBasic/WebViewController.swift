//
//  WebViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! // UIKit이 아니니까 임포트를 따로 해줘야함
    @IBOutlet weak var searchBar: UISearchBar!
    // 넣고싶은 URL 설정
    var destinationURL: String = "https://www.apple.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //웹열기
        openWebPage(url: destinationURL)
    
        // 서치바 기능 위임
        searchBar.delegate = self
        
    }
    // 1. 이 URL신뢰해도 돼? -> 가드문 2. Ok 나 그럼 요청할게 3. 로드할게
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// 이 웹뷰에서 서치바로 검색해야해 open할 때 이거 참고해죠
extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
}
