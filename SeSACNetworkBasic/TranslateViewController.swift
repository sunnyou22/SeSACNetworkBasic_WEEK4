//
//  TranslateViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/28.
//

import UIKit

class TranslateViewController: UIViewController {
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    @IBOutlet weak var userInputTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //나한테 일 맡겨놓이 무슨일하는지 알려줘야징
        userInputTextView.delegate = self
        
        //플레이스 홀더멤버 없기 땜누에 그렇게 보이기 위해 만들어야함
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
//        userInputTextView.resignFirstResponder() // 우선권을 버린다
//        userInputTextView.becomeFirstResponder() // 우선권을 가진다
    }
}


// 알려줄겡
extension TranslateViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 변할 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
                
    // 편집이 시작될 때 커서가 시작될때
    // 텍스트뷰 글자: 플레이스 홀더랑 글자가 같으면 clear. 사용자가 입력하는 글자는 명확한 색깔로 보이게함
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집이 끝났을 때 커서가 없어지는 순간(편집을 끝내는 코드 필요)
    // 텍스트뷰 글자: 사용자가 아무 글자를 안쓰면 플레이스홀더 글자를 보이게 해라
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End ")
        
        // 텍스트뷰의 text는 옵셔널이 아님
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
}

