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
    let formatter = UserDateFormat().setFormatter()
    // 아웃렛의 역할을 해줄거임
    // 코드로 뷰를 짜는 기능이 훨씬 더 많이 남아있음
    // 지금은 키보드 자리에 잘 위치하고 이씀
    
    //MARK: 서버통신을 다른 곳에서 받고 셀 선택시 유저디폴트를 받아오는건?
    // 사용자입장에서 1회차부터 보여지면 최근회차를 가기 힘드니까 배열에 담아버림
    var totalCount: Double = 0
//    typealias userDefaultType = ([Int], String) // 로또 번호들을 담을 배열, 날짜
//    var clickedUserDefaultList: [userDefaultType] = [] // 클릭했던 회차정보를 담는 변수
    var testLottoNumList: [Int]?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.inputView = lottoPickerView
        numberTextField.addTarget(self, action: #selector(keyboardDown), for: .editingDidEndOnExit)
        // 액션이 호출이 안됨.....잘 쓰지 않음
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        numberTextField.delegate = self
    }
    //MARK: 도전과제 (지난주 데이터를 가져와서,,,표현)
    func count() -> [Int] {
        totalCount = floor(Date().timeIntervalSince(formatter.date(from: "2002-12-07")!) / (86400 * 7))
        print(totalCount)
        let numberlist: [Int] = Array(1...Int(totalCount)).reversed()
        return numberlist
    }
    
    func plusDay(add: Int) -> String {
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
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                var lottonumlist: [Int] = []
                
                // 이렇게 받아오지 않으면 화면에 반영되지 않음
                let bonus = json["bnusNo"].intValue
                print(bonus)
                let date = json["drwNoDate"].stringValue
                print(date)
                
                for i in 1...6 {
                    self.lottoNumList[i - 1].text = "\(json["drwtNo\(i)"].intValue)"
                    lottonumlist.append(json["drwtNo\(i)"].intValue)
                }
                self.bonusNum.text = "\(bonus)"
                lottonumlist.append(bonus)
                
                self.numberTextField.text = date
//                let tuple: userDefaultType = (lottonumlist, date)
//                self.clickedUserDefaultList.append(tuple)
                UserDefaults.standard.set(lottonumlist, forKey: "\(number)")
                UserDefaults.standard.set(date, forKey: "\(number)date")
                
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
        // return 10 // 행. 하나의 픽커뷰에 10개의 행이 잇음
        // 만약 따로따로 구현?
        return count().count
    }
    
    // 데이터피커를 선택하면? 편집이 끝난다
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        numberTextField.text = "\(self.requestLotto(number: LottoViewController.numberlist[row]))"
    
        numberTextField.text = "\(count()[row])회차" // 선택이 됐을 때 어떻게 텍스트필트에 어떻게 보여질 건지
        
        //view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [self] in
            // 1초 후 실행될 부분
            self.numberTextField.resignFirstResponder()
            
            if UserDefaults.standard.array(forKey: "\(self.count()[row])") == nil || UserDefaults.standard.string(forKey: "\(self.count()[row])date") == nil {
                self.requestLotto(number: self.count()[row])
            } else {
                let lottoList = UserDefaults.standard.array(forKey: "\(self.count()[row])") as! Array<Int>
                lottoList.forEach { i in
                    print(lottoList)
                    lottoNumList.append(bonusNum)
                    lottoNumList[lottoList.firstIndex(of: i)!].text = "\(i)"
                }
                numberTextField.text = UserDefaults.standard.string(forKey: "\(self.count()[row])date")
            }
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(count()[row])회차" // 타이틀 행에 대한 타이틀이 어떻게 보여지는지
        
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

struct UserDateFormat {
    static let formatter = DateFormatter()
    
    func setFormatter() -> DateFormatter {
        UserDateFormat.formatter.locale = Locale(identifier: "ko_KR")
        UserDateFormat.formatter.dateFormat = "yyyy-MM-dd"
        
        return UserDateFormat.formatter
    }
}


