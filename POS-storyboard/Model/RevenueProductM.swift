//
//  RevenueProductM.swift
//  POS-storyboard
//
//  Created by Wei Shih Chi on 2020/1/10.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class RevenueProductM: NSObject {
    init(_ product_id:String, revenue_id:String, count:Int , amount:Int , totalChooseAnswer:String) {
        self.product_id = product_id
        self.revenue_id = revenue_id
        self.count = count
        self.amount = amount
        self.totalChooseAnswer = totalChooseAnswer
    }
    
    var product_id = ""
    var revenue_id = ""
    var count = 0
    var amount = 0
    var totalChooseAnswer = "";
}
