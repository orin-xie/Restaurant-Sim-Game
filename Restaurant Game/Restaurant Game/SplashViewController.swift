//
//  SplashViewController.swift
//  Restaurant Game
//
//  Created by Orin Xie on 3/17/18.
//  Copyright © 2018 Orin Xie. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    //
    // MARK: - Properties
    //
    
    var autoDismiss = false
    
    //
    // MARK: - IBOutlets
    //
    
    @IBOutlet weak var dismissButton: UIButton!
    
    //
    // MARK: - IBActions
    //
    
    @IBAction func tapDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //
    // MARK: - Lifecyle
    //
    
    override func viewWillAppear(_ animated: Bool) {
        //print("ViewWillAppear")
        
        if self.autoDismiss {
            self.dismissButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.dismiss(animated: true, completion: {
                    print("done")
                })
            }
        }
    }
    
}
