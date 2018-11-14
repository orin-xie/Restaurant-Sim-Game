//
//  EndScreenViewController.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/16/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit
import AVFoundation

class EndScreenViewController: UIViewController {
    
    //
    // MARK: - Properties
    //
    
    var totalBalance : Double?
    var dailySummaryDict = [Int: [Double]]()
    var sounds: AVAudioPlayer?
    
    //
    // MARK: - Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(totalBalance!)
        //print(dailySummaryDict)
        let path = Bundle.main.path(forResource: "applause.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            sounds = try AVAudioPlayer(contentsOf: url)
            sounds?.play()
        } catch {
            print("couldn't load sound file")
        }
        
        //adding an alert that displays the ending balance and starts a new game
        DispatchQueue.main.async {
            let endBalance = String(format: "$%.2f", self.totalBalance!)
            
            let alert = UIAlertController(title: "Congratulations on making it to the end of the week!",
                                          message: "Your ending balance is \(endBalance)",
                                          preferredStyle: .alert)
            
            let newGame = UIAlertAction(title: "Start New Game", style: .default, handler: { action in
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mainVC") as! ViewController
                nextViewController.day = 1
                nextViewController.purchasedDict = [String: Int]()
                nextViewController.dailySummaryDict = [Int: [Double]]()
                self.present(nextViewController, animated:true, completion:nil)
            })
            alert.addAction(newGame)
        
            self.present(alert, animated:true, completion:nil)
        }

    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
