//
//  ExchangeRate_Assignment.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/27.
//

import Foundation
import UIKit
/*
 현재 한국돈 -> 미국달러
 1. 두개의 프로퍼티 한국돈 미국돈
 2. 연산할 환율
 */

// 의미단위가 이상하다...
struct ExchangeRate {
    
    var currencyRate: Double {
        willSet {
            print("currencyRate willSet - 환율 변동 예정: \(currencyRate) -> \(newValue)") // 이때의 currencyRate와
        }
        didSet{
            print("currencyRate didSet - 환율 변동 완료: \(oldValue) -> \(currencyRate)")// 이때의 currencyRate다름 will과 did의 의미를 잘 생각
        }
    }
    
    var USD: Double {
        willSet {
            print("USD willSet - 환전금액: USD: \(newValue)로 환전될 예정")
        }
        didSet {
            print("USD didSet - \(KRW) -> \(USD) 환전되었음")
        }
    }
    
    var KRW: Double {
        get {
            USD * currencyRate
        }
        set {
            USD = newValue / currencyRate
        }
    }
}

var rate = ExchangeRate(currencyRate: 1000, USD: 100)

// get테스트해보기
//rate.KRW = 500000
//rate.currencyRate = 1350
//rate.KRW

//MARK: 07.29

/*
 dataDtectorTypes = .link -> 링크 활성화
 isEditable -> false -> text에 링크가 있으면 자동으로 링크가 설정됨
 */
