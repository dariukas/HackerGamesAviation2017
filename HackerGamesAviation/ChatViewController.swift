//
//  TableViewController.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 29/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var messagesArray: [Dictionary<String, String>] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleMPCReceivedDataWithNotification), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateTableview(){
        chatTableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageIdentifier", for: indexPath)
        let currentMessage = messagesArray[indexPath.row] as Dictionary<String, String>
        
        if let sender = currentMessage["sender"] {
            var senderLabelText: String
            var senderColor: UIColor
            
            if sender == "self"{
                senderLabelText = "I said:"
                senderColor = UIColor.purple
            } else{
                senderLabelText = sender + " said:"
                senderColor = UIColor.orange
            }
            
            cell.detailTextLabel?.text = senderLabelText
            cell.detailTextLabel?.textColor = senderColor
        }
        
        if let message = currentMessage["message"] {
            cell.textLabel?.text = message
        }
        return cell
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let messageText = textField.text
            else {
                return false
        }
        
        let messageDictionary: [String: String] = ["message": messageText]
        sendMessage(messageDictionary, completionHandler: {_ in
            let dictionary: [String: String] = ["sender": "self", "message": messageText]
            messagesArray.append(dictionary)
            self.updateTableview()
        })

        textField.text = ""
        return true
    }
    
    @IBAction func endChat(sender: AnyObject) {
        let messageDictionary: [String: String] = ["message": "_end_chat_"]
        sendMessage(messageDictionary, completionHandler: {manager in
            self.dismiss(animated: true, completion: { () -> Void in
                manager.session.disconnect()
            })
        })
    }
    
    func sendMessage(_ messageDictionary: [String: String], completionHandler: (MPCManager)->Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let manager = appDelegate.mpcManager
            else {
                return
        }
        if manager.sendData(dictionaryWithData: messageDictionary, toPeer: manager.session.connectedPeers[0] as MCPeerID){
            completionHandler(manager)
        }
        else{
            print("Could not send data!")
        }
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        // Get the dictionary containing the data and the source peer from the notification.
        guard let receivedDataDictionary = notification.object as? Dictionary<String, AnyObject>
            else {
                return
        }
        
        // "Extract" the data and the source peer from the received dictionary.
        guard let data = receivedDataDictionary["data"] as? Data, let fromPeer = receivedDataDictionary["fromPeer"] as? MCPeerID
            else {
                return
        }
        
        // Convert the data (NSData) into a Dictionary object.
        guard let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? Dictionary<String, String>
            else {
                return
        }
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"] {
            // Make sure that the message is other than "_end_chat_".
            if message != "_end_chat_"{
                // Create a new dictionary and set the sender and the received message to it.
                let messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": message]
                
                // Add this dictionary to the messagesArray array.
                messagesArray.append(messageDictionary)
                
                // Reload the tableview data and scroll to the bottom using the main thread.
                OperationQueue.main.addOperation({ () -> Void in
                    self.updateTableview()
                })
            } else {
            let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertControllerStyle.alert)
            
            let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let manager = appDelegate.mpcManager
                    else {
                        return
                }
                manager.session.disconnect()
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(doneAction)
            
            OperationQueue.main.addOperation({ () -> Void in
                self.present(alert, animated: true, completion: nil)
            })
        }
        }
    }
    
}
