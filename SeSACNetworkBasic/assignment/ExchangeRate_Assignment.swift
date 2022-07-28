//
//  ExchangeRate_Assignment.swift
//  SeSACNetworkBasic
//
//  Created by 방선우 on 2022/07/27.
//

import Foundation
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
            print("USD willSet - 환전금액: USD: \(newValue / currencyRate)로 환전될 예정")
        }
        didSet {
            print("USD didSet - \(USD) -> \(USD / currencyRate) 환전되었음")
        }
    }
    
    var KRW: Double {
        get {
            currencyRate / USD
        }
        set {
            USD = newValue
        }
    }
}

//var rate = ExchangeRate(currencyRate: 1100, USD: 1)
//
//rate.KRW = 500000
//rate.currencyRate = 1350
//rate.KRW = 500000
