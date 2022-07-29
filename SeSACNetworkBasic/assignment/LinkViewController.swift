//
//  SinkViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/29.
//
import SafariServices
import UIKit

class LinkViewController: UIViewController, UITextViewDelegate {
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


