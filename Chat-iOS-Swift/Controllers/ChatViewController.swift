//
//  ChatViewController.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-28.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController {
    var user: User?
    
    var messages: Array<JSQMessageData> = []
    var socket: SIOSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User()
        self.user?.username = "justintest"
        
        setupUI()
        var url = "http://localhost:8080"
        url = "http://chat-simple.herokuapp.com/"
        connectWebSocket(url)
    }
    
    func setupUI() {
        navigationItem.title = "General"
    }
    
    func connectWebSocket(host: NSString) {
        SIOSocket.socketWithHost(host, response: { (socket: SIOSocket!) -> Void in
            self.socket = socket
            
            socket.onConnect = { () -> () in
                socket.emit("addUser", message: self.user?.username)
            }
            
            socket.on("newMessage", executeBlock: { (response) -> Void in
                if let json = response as? Dictionary<String, String> {
                    dispatch_async(dispatch_get_main_queue(), { () -> () in
                        self.messages.append(Message(body: json["message"]!, sender: json["username"]!))
                        self.finishReceivingMessage()
                    })
                }
            })
        })
    }
    
    // MARK: JSQMessagesCollectionViewDataSource
    
    func sender() -> String! {
        return self.user?.username
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        cell.textView.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
//        return nil
        return JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.blueColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        return nil
//        return JSQMessagesAvatarFactory.avatarWithUserInitials("JJ", backgroundColor: UIColor.greenColor(), textColor: UIColor.blackColor(), font: FontUtil.helveticaNeueLightFont(10), diameter: 10)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        self.socket?.emit("newMessage", message: text)
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        var message = JSQMessage(text: text, sender: sender)
        self.messages.append(message)
        self.finishSendingMessage()
    }
}
