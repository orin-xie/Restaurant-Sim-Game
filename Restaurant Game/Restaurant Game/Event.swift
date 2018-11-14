//
//  Event.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/16/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit

class Event {
    let name: String
    let description: String
    let value: Double
    let image: UIImage
    let soundPath: String
    
    init(name: String, description: String, value: Double, image: UIImage, sound: String) {
        self.name = name
        self.description = description
        self.value = value
        self.image = image
        self.soundPath = sound
    }
    

}
