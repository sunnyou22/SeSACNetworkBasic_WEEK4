//
//  AssignmentWebViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/28.
//

import UIKit
import WebKit

class AssignmentWebViewController: UIViewController {
    var destinationURL = "https://www.daum.net"
    
    @IBOutlet weak var testTextView: UITextView!
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var reloadBtn: UIBarButtonItem!
    @IBOutlet weak var gofowardBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar.barTintColor = .lightGray
        
        searchBar.delegate = self
        // 확장한 기능을 해당서치바에 연결해주는 거임
        openWebPage(urlstr: destinationURL)
        // 아래 작업이 끝나면 실질적으로 url 연결
    }
    
    //MARK: 툴바 아이템마다 기능 넣어주기
    @IBAction func gobackButtonClicked(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func reloadButtonClicked(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func goFowardButtonClicked(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    //MARK: URL 연결
    func openWebPage(urlstr: String) {
        // 먼저 유효한 URL값인지 판단하기
        // let urlComponents = URLComponents(string: url) -> 생각쓰~
        guard let url = URL(string: urlstr) else {
            print("Invaild URL")
            return
        }
        
        // 이 url을 보여주세요~
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//MARK: searchBar에 이런기능을 넣어주세요
extension AssignmentWebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print("서치바에 텍스트 없음")
            return
        }
        openWebPage(urlstr: text)
    }
}

