//
//  DailySummaryViewController.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/15/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit
import AVFoundation

class DailySummaryViewController: UIViewController {
    
    //
    // MARK: - Properties
    //
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var summaryText: UILabel!
    @IBOutlet weak var nextDayButton: UIBarButtonItem!
    @IBOutlet weak var endWeekButton: UIBarButtonItem!
    
    var menuArray = [MenuItem]()
    var eventsArray = [Event]()
    var createdDict = [String: Int]()
    var day : Int?
    var totalBalance : Double?
    var totalRev = 0.00
    var dailySummaryDict = [Int: [Double]]()
    var sounds: AVAudioPlayer?
    
    //
    // MARK: - Lifecycle
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createEvents()
        
        //determine whether or not a special event happens and how to handle it
        let eventGeneratorNum = Int(arc4random_uniform(12))
        //make sure the event doesn't cause a negative balance
        if eventGeneratorNum <= eventsArray.count - 1 && totalBalance! + eventsArray[eventGeneratorNum].value >= 0  {
            let event = eventsArray[eventGeneratorNum]
            let eventImageView = UIImageView(image: event.image)
            eventImageView.frame = UIScreen.main.bounds
            eventImageView.backgroundColor = .black
            eventImageView.contentMode = .scaleAspectFit
            eventImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            eventImageView.addGestureRecognizer(tap)
            self.view.addSubview(eventImageView)
            
            let path = Bundle.main.path(forResource: event.soundPath, ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                sounds = try AVAudioPlayer(contentsOf: url)
                sounds?.play()
            } catch {
                print("couldn't load sound file")
            }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: event.name,
                                              message: event.description,
                                              preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated:true, completion:nil)
            }
            
            if event.value >= 0 {
                let valueFormatted = String(format: "$%.2f", event.value)
                summaryText.text = "\(event.name) \nNice! You gain \(valueFormatted)!"
            } else {
                let valueFormatted = String(format: "$%.2f", event.value)
                summaryText.text = "\(event.name) \nOh no! You lost \(valueFormatted)!"
            }
            totalRev = totalRev + event.value
        }
        
        //if it's the end of the week, show button to end the game
        dayLabel.text = "Day \(String(describing: day!))"
        if day == 7 {
            endWeekButton.tintColor = nil
            endWeekButton.isEnabled = true
            nextDayButton.tintColor = UIColor.clear
            nextDayButton.isEnabled = false
        }

        generateOrders()
        writeSummary()
    }
    
    //
    // MARK: - Helper functions
    //
    
    //randomly generate how many of each item is ordered based on its popularity
    func generateOrders() {
        for item in menuArray {
            item.orders = 0
            
            if item.popularity == "High" {
                item.orders = Int(arc4random_uniform(10) + 5)
            } else if item.popularity == "Medium" {
                item.orders = Int(arc4random_uniform(7) + 2)
            } else {
                item.orders = Int(arc4random_uniform(5))
            }
        }
    }
    
    //write how much revenue was earned from each item to the view
    func writeSummary() {
        for item in menuArray {
            if let createdNum = createdDict[item.name] {
                if createdNum > 0 {
                    //print(item.name)
                    //print(createdNum)
                    //print(item.orders)
                    //if we made less than the number of orders
                    if createdNum <= item.orders {
                        totalRev += Double(createdNum) * item.revenue
                        let revenue = String(format: "$%.2f", Double(createdNum) * item.revenue)
                        summaryText.text = summaryText.text! + "\n\nYou made \(createdNum) \(item.name)s, and there were \(item.orders) orders. You sold out! \nYou made \(revenue) from selling \(item.name)s"
                    //if we made more than the number of orders
                    } else {
                        totalRev += Double(item.orders) * item.revenue
                        let revenue = String(format: "$%.2f", Double(item.orders) * item.revenue)
                        summaryText.text = summaryText.text! + "\n\nYou made \(createdNum) \(item.name)s, but unfortunately there were only \(item.orders) orders. \nYou made \(revenue) from selling \(item.name)s"
                    }
                }
            }
        }
        let totalRevFormatted = String(format: "$%.2f", totalRev)
        totalBalance! += totalRev
        let totalBalFormatted = String(format: "$%.2f", totalBalance!)
        
        //making this part of the UILabel's text bold
        let totals = "\n\nYou made a total of \(totalRevFormatted) for day \(String(describing: day!))! \nYour updated total balance is now \(totalBalFormatted)"
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString = NSMutableAttributedString(string: totals, attributes: attrs)
        let normalString = NSMutableAttributedString(string: summaryText.text!)
        normalString.append(attributedString)
        summaryText.attributedText = normalString
        summaryText.sizeToFit()
        scrollView.contentSize = summaryText.frame.size
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    //create the events and add them to an array
    func createEvents(){
        let bankError = Event(name: "Bank error in your favor!", description: "You collect $200, and didn't even have to pass 'Go!', but you can't help but wonder how this bank is still in business..", value: 200, image: UIImage(named: "bank_error")!, sound: "yay.mp3")
        let sharknado = Event(name: "Sharknado hits New York!", description: "Oh no, not another sharknado has hit! Unfortunately, it doesn't look like Tara Reid is anywhere to save the day this time.. you take $40 in damages", value: -40, image: UIImage(named: "sharknado")!, sound: "Sad_Trombone.mp3")
        let fire = Event(name: "There's a fire!", description: "Luckily, it's only a small kitchen fire, and you're able to put it out quickly without too much damage. It will still cost you $25 to make repairs though", value: -25, image: UIImage(named: "fire")!, sound: "Sad_Trombone.mp3")
        let lottery = Event(name: "You won the lottery!", description: "Unfortunately, you're not a millionaire quite yet. You only won $500, but hey, that's still pretty good right?", value: 500, image: UIImage(named: "lottery")!, sound: "yay.mp3")
        let ratInfestation = Event(name: "You discover rats in the kitchen!", description: "Guess you really should have invested more in health and cleanliness.. shame on you. You pay $20 to hire an exterminator.", value: -20, image: UIImage(named: "rats")!, sound: "Sad_Trombone.mp3")
        let oprahShoutout = Event(name: "Oprah gives you a shoutout on her show!", description: "You won a NEW CAR!! Just kidding.. you get some free publicity though, and an Oprah fan tips you $1 (better than nothing..?)", value: 1, image: UIImage(named: "oprah")!, sound: "yay.mp3")
        
        self.eventsArray.append(contentsOf: [bankError, sharknado, fire, lottery, ratInfestation, oprahShoutout])
    }

    //
    // MARK: - Navigation
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //advances the day
        if segue.identifier == "nextDay" {
            let destinationVC = segue.destination as! ViewController
            dailySummaryDict[day!] = [dailySummaryDict[day!]![0], totalRev]
            destinationVC.dailySummaryDict = self.dailySummaryDict
            destinationVC.purchasedDict = [String: Int]()
            destinationVC.day = self.day! + 1
            destinationVC.menuArray = menuArray
            destinationVC.totalAvailableNum = totalBalance
        }
        
        //end the week/game
        if segue.identifier == "endWeek" {
            let destinationVC = segue.destination as! EndScreenViewController
            dailySummaryDict[day!] = [dailySummaryDict[day!]![0], totalRev]
            destinationVC.dailySummaryDict = self.dailySummaryDict
            destinationVC.totalBalance = self.totalBalance
        }
    }
    
}
