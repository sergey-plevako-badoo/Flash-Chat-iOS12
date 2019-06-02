//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
    
        //TODO: Set the tapGesture here:
        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        // messageTableView.addGestureRecognizer(tapGesture)
        configureTableView()
        retrieveMessages()

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        //let messageArray = ["1st message", "2nd message", "3rd message"]
        //cell.messageBody.text = messageArray[indexPath.row]
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var chatController = segue.destination as! ChatViewController
        chatController.chatName = "Chat Title"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToChatto", sender: self)
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MesssageBody"] ?? ""
            let sender = snapshotValue["Sender"] ?? ""
            
            print(text, sender)
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch  {
            print("error: there was a problem logging out")
        }
        
    }
    


}
