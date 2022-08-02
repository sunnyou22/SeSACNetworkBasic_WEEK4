//
//  LottoViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/28.
//

//임포트할 때 애플프레임워크를 알파벳순서로 해주고 다음 한ㄱ칸뛰고 라이브러리 써줌
import UIKit
import WebKit

import Alamofire
import SwiftyJSON


class LottoViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet var lottoNumList: [UILabel]!
    @IBOutlet weak var bonusNum: UILabel!

//    @IBOutlet weak var lottoPickerView: UIPickerView!
    var lottoPickerView = UIPickerView()

    // 아웃렛의 역할을 해줄거임
    // 코드로 뷰를 짜는 기능이 훨씬 더 많이 남아있음
    // 지금은 키보드 자리에 잘 위치하고 이씀
    
    // 사용자입장에서 1회차부터 보여지면 최근회차를 가기 힘드니까 배열에 담아버림

    let numberlist: [Int] = Array(1...UserDefaults.standard.integer(forKey: "countDay")).reversed()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 텍스트필트를 클릭할 때 키보드가 아니라 키보드자리에 뷰를 심어놓은 것
        // 지금 텍스트필드로 구현을 했기 때문에 텍스트필드의 값이 변하면 키보드가 올라옴
        // 그럼 키보드가 데이터피커를 가려버리기 때문에 그걸 방지하기 위해서 뷰를 심음
        // 그 뷰 자리에 픽커뷰를 넣어뒀지만 2개가 지금 심어져있음
        // InputView는 텍스트 필드와 텍스트 뷰에서만 거의 사용하는 기능임 대신 키보드는 못 씀
        numberTextField.inputView = lottoPickerView
        numberTextField.addTarget(self, action: #selector(keyboardDown), for: .editingDidEndOnExit)
        // 액션이 호출이 안됨.....잘 쓰지 않음
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        numberTextField.delegate = self
    }
    
   func count() -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
       var countDay: Int = 0
        
       
       print(plusDay(add: 7))
       print(formatter.string(from: Date()))
       
       print(plusDay(add: 7 * countDay) > formatter.string(from: Date())) // true
       print(UserDefaults.standard.integer(forKey: "countDay"))
       while plusDay(add: 7 * UserDefaults.standard.integer(forKey: "countDay")) < formatter.string(from: Date()) {
            print(countDay)
           countDay += 1
           UserDefaults.standard.set(countDay, forKey: "countDay")
           
        }
       
       print(countDay)
        return countDay
    }
    
    
   func plusDay(add: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        // 클로저를 사용해서 더 간결하게 갈 수 있지 않을까 puls함수를 클로저로 대체..하는...무슨 방법이 있지 ..않을가..
        let plusday = Calendar.current.date(byAdding: .day, value: add, to: formatter.date(from: "2002-12-07")!)
        
        return formatter.string(from: plusday!)
    }

    
    @objc
    func keyboardDown() {
        print("키보드 다운")
        numberTextField.resignFirstResponder()
    }
    
    func requestLotto(number: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        print(number)
        //request부터 swiftyJson코드임,  validate() -> 유효성 검증
        //AF: 200 ~ 299 status code 301
        //responseJSON 제이슨 형태로 받아오겟다
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                // 이렇게 받아오지 않으면 화면에 반영되지 않음
                let bonus = json["bnusNo"].intValue
                print(bonus)
                let date = json["drwNoDate"].stringValue
                print(date)
                
                for i in 1...6 {
                    self.lottoNumList[i - 1].text = "\(json["drwtNo\(i)"].intValue)"
                }
                self.bonusNum.text = "\(bonus)"
       
                self.numberTextField.text = date
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//MARK: 채택할 프토토콜을 따로 빼줌
// 하나의 클래스 안에 프로토콜을 다 채택할 수 있지만 가독성을 위해 기능을 빼줌, 다른 파일에서 정리할수도 있음 하지만 현업에서는 그냥 이렇게 하단에 만들어주기도 함 찾기가 힘들듯,,?
// 수정할 일이 거의 없으니까 그냥 접어서 관리함
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 열. 몇개 픽커뷰할거냐
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 10 // 행. 하나의 픽커뷰에 10개의 행이 잇음
        // 만약 따로따로 구현?
        return numberlist.count
    }
    
    // 데이터피커를 선택하면? 편집이 끝난다
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        numberTextField.text = "\(self.requestLotto(number: LottoViewController.numberlist[row]))"
        
        numberTextField.text = "\(numberlist[row])회차" // 선택이 됐을 때 어떻게 텍스트필트에 어떻게 보여질 건지
        //view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
          // 1초 후 실행될 부분
            self.requestLotto(number: self.numberlist[row])
            self.numberTextField.resignFirstResponder()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberlist[row])회차" // 타이틀 행에 대한 타이틀이 어떻게 보여지는지
        
    }
}
    extension LottoViewController: UITextFieldDelegate {
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            numberTextField.isUserInteractionEnabled = false
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            numberTextField.isUserInteractionEnabled = true
        }
    }
//
//protocol TestPlusDay {
//    func plusDay(add: Int) -> String
//}
//
//extension TestPlusDay {
//    func plusDay(add: Int) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "yyyy-MM-dd"
//
//        let plusday = Calendar.current.date(byAdding: .day, value: add, to: formatter.date(from: "2022-12-07")!)
//
//        return formatter.string(from: plusday!)
//    }
//}
