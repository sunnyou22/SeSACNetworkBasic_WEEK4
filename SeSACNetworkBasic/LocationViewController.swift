//
//  LocationViewController.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/29.
//

import UIKit

//권한설정은 앱이 켜는 최초한번 만약 거부하면 이후는 개발자가 설정해줘야함

class LocationViewController: UIViewController {
    @IBOutlet weak var downloadImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    //Notification
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UN -> 유저노티피케이션의 약자
        // 이 친구가 선행돼야 권한요청을 할 수 있음
        
        
        //Custom Font
        for family in UIFont.familyNames {
            print("=========\(family)==========")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }
        
        
        requesAutorization()
    }
    
    @IBAction func downloadImage(_ sender: UIButton) {
      //비동기로 만들어주면 좋음
        let url = "https://apod.nasa.gov/apod/image/2208/M13_final2_sinfirma.jpg"
        print("1", Thread.isMainThread)
        
        // 코드가 순서대로 동작했다가 여기 안에 넣어서 그 순서가 깨짐
        DispatchQueue.global().async { // 동시 여러 작업 가능하게 해줘
            print("2", Thread.isMainThread)
            let data = try! Data(contentsOf: URL(string: url)!)
            let image = UIImage(data: data)
            
            // 그래서 main에서 움직일 수 있게 따로 담아줌
            DispatchQueue.main.async {
                print("3", Thread.isMainThread)
                self.imageView.image = image
            }
        }
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
       sendNotification()
    }
    
    //Notification 2. 권한요정
    func requesAutorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            
            // 성공했을 때
            if success {
                self.sendNotification() // self는 함수를 뜻함
            } else {
                print("ERROR")
            }
        }
    }
    
    //Notification 3. 권한 허용한 사용자에게 알림 요청(언제? 어떤 컨텐츠?)
    //iOS 시스템에서 알림을 담당 > 알림을 등록
    
    /*
     - 권한 허용해야만 알림이 온다
     - 권한 허용 문구 시스템적으로 최조 한번만 온다.
        - 허용이 안된 경우 애플 설정으로 직접 유도하는 코드를 구성 해야한다.
     - 기본적으로 알림은 포그라운드에서 수신되지 않는다
     - 로컬알림에서 60초 이상 반복 가능 / 갯수 제한 64개(전체알림갯수? identifier기준? 찾아보기) / 커스텀 사운듸
     
     1. 뱃지제거 -> sceneDidBecomeActive(_ scene: UIScene) {
     2. 노티제거 -> 노티 유효기간은? application(_ application: UIApplication, didFinishLaunchingWithOptions
     3. 포그라운드 수신 -> UNUserNotificationCenterDelegate프로토콜 채택 및 메서드로 해결
     
     +a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면?
     - 포그라운드 수실 -> 특정화면에서는 안 받고 특정 조건에 대해서만 포그라운드수신을 받고싶다면?
     - iOS15 집중모드 5-6 우선순위 존재
     */
    
    func sendNotification() {
        // 폰트크기 굵기 다 못바꿈
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.subtitle = "저는 따끔따끔 다마고치입니다. 배고파요"
        notificationContent.badge = 40
        
        //언제 보낼거야?
        // 시간간격일 때는 60초이어야 스레드 오류 안남
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        
        var dateComponent = DateComponents() // 인스턴스를 만들고 해당되는 것만 가져오기
        dateComponent.minute = 15 // 15분에 해당할 때만 알림이 옴
        
        //캘린터 버전
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // 아이덴티파이어를 다양하게 쓰면 푸시가 여러개가 쌓이고 하나만 쌓이면 알림이 하나만 옴
        //identifier:
        //만약 알림 관리 할 필요 없으면 -> 알림 클릭하면 앱을 켜주는 정도 그냥 랜덤하게 보내면 \(Date()) -> 날짜가 겹칠일은 거의 없으니까
        //만약 알림 관리할 필요가 있으면 -> 특정아이텐티파이어가 필요, 규칙
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
        
//        notificationCenter.add(request) { error //이렇게 에러관리 가능
            
        
    }
}
