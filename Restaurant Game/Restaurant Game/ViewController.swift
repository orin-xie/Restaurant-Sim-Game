//
//  ViewController.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/12/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //
    // MARK: - Properties
    //
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var totalAvailable: UILabel!
    @IBOutlet weak var totalSpent: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    var totalAvailableNum: Double?
    var totalSpentNum: Double?
    var menuArray = [MenuItem]()
    var purchasedDict = [String: Int]()
    var dailySummaryDict = [Int: [Double]]()
    var day = 1
    var sounds: AVAudioPlayer?
    
    //
    // MARK: - Lifecyle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("avail at start \(String(describing: totalAvailableNum))")
        
        dayLabel.text = "Day \(day)"
        if day == 1 {
            createMenuItems()
            totalAvailableNum = 25.00
        }
        totalAvailable.text = String(format: "$%.2f", totalAvailableNum!)
        totalSpentNum = 0.00
        totalSpent.text = String(format: "$%.2f", totalSpentNum!)
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    //
    // MARK: - Table View
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
        
    }
    
    //creating cell and writing all the text
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 104
        tableView.tableFooterView = UIView()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        let index = indexPath.row
        cell.itemName.text = menuArray[index].name
        cell.itemRev.text = String(format: "$%.2f", menuArray[index].revenue)
        cell.itemCost.text = String(format: "$%.2f", menuArray[index].cost)
        cell.itemPop.text = menuArray[index].popularity
        cell.itemImage.image = menuArray[index].image
        cell.itemButton.tag = index
        cell.itemRemoveButton.tag = index
        return cell
    }
    
    //
    // MARK: - Navigation
    //
    
    //transfer any necessary data to DailySummaryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startDay" {
            let destinationVC = segue.destination as! DailySummaryViewController
            destinationVC.createdDict = purchasedDict
            destinationVC.day = self.day
            destinationVC.menuArray = menuArray
            destinationVC.totalBalance = totalAvailableNum
            dailySummaryDict[day] = [totalSpentNum!]
            destinationVC.dailySummaryDict = self.dailySummaryDict
            for item in menuArray {
                item.count = 0
            }
        }
     }
    
    //
    // MARK: - Helper functions and button actions
    //
    
    //creating the menu items for the table
    func createMenuItems(){
        let hamburger = MenuItem(name: "Hamburger", revenue: 7.50, cost: 2.00, popularity: "High", image: UIImage(named: "hamburger")!)
        let pizzaSlice = MenuItem(name: "Pizza Slice", revenue: 2.00, cost: 0.50, popularity: "High", image: UIImage(named: "pizza")!)
        let frenchFry = MenuItem(name: "French Fry", revenue: 5.50, cost: 1.00, popularity: "High", image: UIImage(named: "fries")!)
        let taco = MenuItem(name: "Taco", revenue: 2.50, cost: 0.50, popularity: "Medium", image: UIImage(named: "taco")!)
        let burrito = MenuItem(name: "Burrito", revenue: 7.00, cost: 1.75, popularity: "Medium", image: UIImage(named: "burrito")!)
        let hotdog = MenuItem(name: "Hotdog", revenue: 1.50, cost: 0.25, popularity: "Medium", image: UIImage(named: "hotdog")!)
        let sub = MenuItem(name: "Sub", revenue: 5.00, cost: 0.75, popularity: "Low", image: UIImage(named: "sub")!)
        let drumstick = MenuItem(name: "Drumstick", revenue: 8.00, cost: 2.50, popularity: "Low", image: UIImage(named: "friedchicken")!)
        let cake = MenuItem(name: "Cake", revenue: 6.00, cost: 1.00, popularity: "Low", image: UIImage(named: "cake")!)
        let iceCream = MenuItem(name: "Ice Cream", revenue: 4.00, cost: 0.50, popularity: "Medium", image: UIImage(named: "icecream")!)
        
        self.menuArray.append(contentsOf: [hamburger, pizzaSlice, frenchFry, taco, burrito, hotdog, sub, drumstick, cake, iceCream])
    }

    //adding an item to the cart
    @IBAction func tapAddItem(_ sender: UIButton) {
        print("tapped")
        print(sender.tag)
        if totalAvailableNum! >= menuArray[sender.tag].cost {
            totalAvailableNum =  totalAvailableNum! - menuArray[sender.tag].cost
            totalSpentNum = totalSpentNum! + menuArray[sender.tag].cost
            totalAvailable.text = String(format: "$%.2f", totalAvailableNum!)
            totalSpent.text = String(format: "$%.2f", totalSpentNum!)
            
            //if item doesn't exist in dictionary, create it
            if purchasedDict[menuArray[sender.tag].name] == nil {
                purchasedDict[menuArray[sender.tag].name] = 1
            } else {
                purchasedDict[menuArray[sender.tag].name]! += 1
            }
            
            //add button sound
            let path = Bundle.main.path(forResource: "coinsound.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                sounds = try AVAudioPlayer(contentsOf: url)
                sounds?.play()
            } catch {
                print("couldn't load sound file")
            }
            
            //update text to reflect how many of the item is purchased
            menuArray[sender.tag].count += 1
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = menuTableView.cellForRow(at: indexPath) as! MenuItemCell
            cell.itemName.text = menuArray[sender.tag].name + " (\(menuArray[sender.tag].count))"
        } else {
            //print("not enough funds")
            let path = Bundle.main.path(forResource: "buzzer.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                sounds = try AVAudioPlayer(contentsOf: url)
                sounds?.play()
            } catch {
                print("couldn't load sound file")
            }
        }
    }
    
    //removing an item from the cart
    @IBAction func tapMinusItem(_ sender: UIButton) {
        print("tapped")
        print(sender.tag)
        if menuArray[sender.tag].count > 0 {
            totalAvailableNum =  totalAvailableNum! + menuArray[sender.tag].cost
            totalSpentNum = totalSpentNum! - menuArray[sender.tag].cost
            totalAvailable.text = String(format: "$%.2f", totalAvailableNum!)
            totalSpent.text = String(format: "$%.2f", totalSpentNum!)
            purchasedDict[menuArray[sender.tag].name]! -= 1

            //add button sound
            let path = Bundle.main.path(forResource: "coinsound.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                sounds = try AVAudioPlayer(contentsOf: url)
                sounds?.play()
            } catch {
                print("couldn't load sound file")
            }
            
            //update text to reflect how many of the item is purchased
            menuArray[sender.tag].count -= 1
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = menuTableView.cellForRow(at: indexPath) as! MenuItemCell
            cell.itemName.text = menuArray[sender.tag].name + " (\(menuArray[sender.tag].count))"
        } else {
            //print("not enough funds")
            let path = Bundle.main.path(forResource: "buzzer.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                sounds = try AVAudioPlayer(contentsOf: url)
                sounds?.play()
            } catch {
                print("couldn't load sound file")
            }
        }
    }
    
    
}

