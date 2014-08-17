//
//  ChatViewController.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-28.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController, TextInputViewDelegate {
    var user: User?
    var textInputView: TextInputView?
    
    var messages: Array<Message> = []
    // TODO: socket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        connectWebSocket("http://localhost:8080")
    }
    
    func setupUI() {
        navigationItem.title = "General"
        navigationController.setToolbarHidden(false, animated: false)
        setupInputView()
    }
    
    func setupInputView() {
        textInputView = TextInputView(frame: navigationController.toolbar.bounds)
        textInputView!.delegate = self
        self.setToolbarItems([UIBarButtonItem(customView: textInputView)], animated: false)
        // TODO
    }
    
    func connectWebSocket(host: NSString) {
        // TODO
    }
    
    func textInputViewWillBeginEditing(textInputView: TextInputView) {
        textInputView.becomeFirstResponder()
    }
    
    
}
