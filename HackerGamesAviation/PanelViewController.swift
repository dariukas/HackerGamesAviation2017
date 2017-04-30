//
//  PanelViewController.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 30/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PanelViewController: UIViewController {

    @IBOutlet weak var goToMapBtn: UIButton!
    @IBOutlet weak var goToChatBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addStylesTo(button: goToMapBtn)
        addStylesTo(button: goToChatBtn)
    }
    
    func addStylesTo(button: UIButton) {
        button.layer.cornerRadius = 0.4 * button.bounds.size.width
        button.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
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
