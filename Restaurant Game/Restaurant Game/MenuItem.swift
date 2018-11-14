//
//  MenuItem.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/12/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit

class MenuItem {
    let name: String
    var revenue: Double
    var cost: Double
    let profit: Double
    var popularity: String
    let image: UIImage
    var count: Int
    var orders: Int
    
    init(name: String, revenue: Double, cost: Double, popularity: String, image: UIImage) {
        self.name = name
        self.revenue = revenue
        self.cost = cost
        self.profit = revenue - cost
        self.popularity = popularity
        self.image = image
        self.count = 0
        self.orders = 0
    }
    
    /*func dumpMenuItem() {
        print("Menu Item: name= \(self.name), image= \(self.image)")
    }*/
}
