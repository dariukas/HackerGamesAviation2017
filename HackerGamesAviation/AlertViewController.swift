//
//  AlertViewController.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 30/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

//http://www.hackingdream.net/2017/04/webgl-graphics-acceleration-google-earth-cannot-loaded.html

import UIKit

class AlertViewController: UIAlertController {
    
    static var isAdvertising: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAction(visibilityAction())
        self.addAction(cancelAction())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func visibilityAction() -> UIAlertAction {
        var actionTitle: String
        if AlertViewController.isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }
        else{
            actionTitle = "Make me visible to others"
        }
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let manager = appDelegate.mpcManager
                else {
                    return
            }
            if AlertViewController.isAdvertising == true {
                manager.advertiser.stopAdvertisingPeer()
            }
            else{
                manager.advertiser.startAdvertisingPeer()
            }
            
            AlertViewController.isAdvertising = !AlertViewController.isAdvertising
        }
        return visibilityAction
    }
    
    private func cancelAction() -> UIAlertAction {
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        return cancelAction
    }
    
    
    
}
