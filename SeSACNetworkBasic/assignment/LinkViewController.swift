//
//  SinkViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/29.
//
import SafariServices
import UIKit

class LinkViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testTextView: UITextView! {
        didSet {
            testTextView.delegate = self
            testTextView.text = "가랏 https://g-y-e-o-m.tistory.com/158"
            testTextView.isSelectable = true
            testTextView.isEditable = false
            testTextView.dataDetectorTypes = .link
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.attributedText = label.attributedText // 이걸 필수적으로 넣어줘야 반영
    }
 
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safari: SFSafariViewController = SFSafariViewController(url: URL)
        self.present(safari, animated: true) {
            print("인앱")
        }
//        interaction.rawValue == 0
//        print("interactionCase", interaction.rawValue == 1)
        return false
    }
}

let label: UILabel = {
    let label = UILabel()
    let attributedString = NSMutableAttributedString(string: "첫번째 문장")
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(named: "2-1")
    imageAttachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
    attributedString.append(NSAttributedString(attachment: imageAttachment))
    
    label.attributedText = attributedString
    return label
}()
