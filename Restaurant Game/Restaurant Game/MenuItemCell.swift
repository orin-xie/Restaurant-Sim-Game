//
//  MenuItemCell.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/12/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UITextView!
    @IBOutlet weak var itemRev: UITextView!
    @IBOutlet weak var itemCost: UITextView!
    @IBOutlet weak var itemPop: UITextView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var itemRemoveButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
