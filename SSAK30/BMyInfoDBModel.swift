//
//  MyInfoDBModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class BMyInfoDBModel:NSObject {
    
    var uSeqno: String?
    var uBuySell: String?
    var uImage: String?
    var uName: String?
    var uPassword:String?
    var uPhone:String?
    var uEmail:String?
    var totalCash: String?
    var sellSeqno: String?
    var sellImage: String?
    var sellTitle: String?
    var priceEA: String?
    var totalEA: String?
    var sSeqno: String?
    var reviewSeq: String?
    var reviewListImage: String?
    var reviewListTitle: String?
    
    override init() {
            
    }
    
    init(uImage: String, uName: String, totalCash:String, uPassword:String, uPhone:String, uEmail:String) {
        self.uImage = uImage
        self.uName = uName
        self.totalCash = totalCash
        self.uPassword = uPassword
        self.uPhone = uPhone
        self.uEmail = uEmail
    }

    init(sellSeqno: String, sellImage: String, sellTitle: String, priceEA: String, totalEA: String, sSeqno: String){
        self.sellSeqno = sellSeqno
        self.sellImage = sellImage
        self.sellTitle = sellTitle
        self.priceEA = priceEA
        self.totalEA = totalEA
        self.sSeqno = sSeqno
    }
    
    init(reviewSeq: String, reviewListImage: String, reviewListTitle: String){
        self.reviewSeq = reviewSeq
        self.reviewListImage = reviewListImage
        self.reviewListTitle = reviewListTitle
    }

    init(uSeqno: String, uBuySell: String){
        self.uSeqno = uSeqno
        self.uBuySell = uBuySell
    }
}
