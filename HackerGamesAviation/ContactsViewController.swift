//
//  ContactsViewController.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 30/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ContactsViewController: UIViewController, MPCManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contactsTableView: UITableView!
    var contacts = [MCPeerID]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let manager = appDelegate.mpcManager {
            manager.delegate = self
            manager.browser.startBrowsingForPeers()
            manager.advertiser.startAdvertisingPeer()
            contacts = manager.foundPeers
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactIdentifier", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].displayName
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let manager = appDelegate.mpcManager, let session = manager.session
            else {
                return
        }
        let selectedPeer =  manager.foundPeers[indexPath.row] as MCPeerID
        manager.browser.invitePeer(selectedPeer, to: session, withContext: nil, timeout: 20)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - MPCManagerDelegate
    
    internal func foundPeer() {
        contactsTableView.reloadData()
    }
    
    internal func lostPeer() {
        contactsTableView.reloadData()
    }
    
    internal func invitationWasReceived(fromPeer: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let manager = appDelegate.mpcManager
            else {
                return
        }
        
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            manager.invitationHandler(true, manager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            manager.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    internal func connectedWithPeer(peerID: MCPeerID) {
        OperationQueue.main.addOperation { () -> Void in
            self.performSegue(withIdentifier: "idSegueChat", sender: self)
        }
    }
    
    @IBAction func startStopAdvertising(sender: AnyObject) {
        AlertViewController.isAdvertising = true
        let actionSheet = AlertViewController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
