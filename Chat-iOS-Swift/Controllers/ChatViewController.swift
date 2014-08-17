//
//  ChatViewController.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-28.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

protocol ChatViewControllerDelegate {
    func chatViewControllerDidLogout(chatViewController: ChatViewController)
}

class ChatViewController: JSQMessagesViewController, UIAlertViewDelegate {
    var delegate: ChatViewControllerDelegate?
    
    var user: User?
    
    private var messages: Array<JSQMessageData> = []
    private var socket: SIOSocket?
    private var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    private var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleBlueColor())
    private var avatars = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let username = self.user?.username {
            var image = JSQMessagesAvatarFactory.avatarWithUserInitials(avatarLetters(username),
                backgroundColor: UIColor(white: CGFloat(0.85), alpha: 1),
                textColor: UIColor(white: 0.6, alpha: 1),
                font: UIFont.systemFontOfSize(14),
                diameter: UInt(self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width))
            self.avatars[username] = image
        }
        
        setupUI()
        var url = "http://localhost:8080"
        url = "http://chat-simple.herokuapp.com/"
        connectWebSocket(url)
    }
    
    func setupUI() {
        navigationItem.title = "General"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "options")
    }
    
    func options() {
        UIAlertView(title: "Log out", message: "Are you sure you want to log out?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
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
    
    func avatarLetters(username: String) -> String! {
        let nsstring = username as NSString
        return nsstring.substringToIndex(2)
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
        
        var message = self.messages[indexPath.item]
        if message.sender() == self.sender() {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        var message = self.messages[indexPath.item]
        
        if message.sender() == self.sender() {
            return UIImageView(image: self.outgoingBubbleImageView.image, highlightedImage: self.outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: self.incomingBubbleImageView.image, highlightedImage: self.incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        var message = self.messages[indexPath.item]
        if let avatarImage = self.avatars[message.sender()] {
            return UIImageView(image: avatarImage)
        }
        
        var avatarImage = JSQMessagesAvatarFactory.avatarWithUserInitials(avatarLetters(message.sender()),
            backgroundColor: UIColor(white: CGFloat(0.85), alpha: 1),
            textColor: UIColor(white: 0.6, alpha: 1),
            font: UIFont.systemFontOfSize(14),
            diameter: UInt(self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width))
        self.avatars[message.sender()] = avatarImage
        return UIImageView(image: avatarImage)
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
    
    // MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.delegate?.chatViewControllerDidLogout(self)
        }
    }
}
