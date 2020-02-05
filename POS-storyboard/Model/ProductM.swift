//
//  ProductM.swift
//  POS-storyboard
//
//  Created by Wei Shih Chi on 2020/1/10.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class ProductM: NSObject {
    init(_ id:String, name:String, price: Int) {
        self.id = id
        self.name = name
        self.price = price
    }
    
    var id = ""
    var name = ""
    var price = 0
}
