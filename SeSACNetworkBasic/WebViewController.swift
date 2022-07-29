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
    
    var destinationURL: String = "https://www.apple.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        openWebPage(url: destinationURL)
    
        
        searchBar.delegate = self
        
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
}
