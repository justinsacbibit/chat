//
//  ChooseUsernameViewController.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-28.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

protocol ChooseUsernameViewControllerDelegate {
    func chooseUsernameViewControllerDidCancel(chooseUsernameViewController: ChooseUsernameViewController)
    func chooseUsernameViewController(chooseUsernameViewController: ChooseUsernameViewController, didPickUsername username: String?)
}

class ChooseUsernameViewController: UITableViewController {
    let kTextFieldCellIdentifier = "TextFieldCell"
    
    var delegate: ChooseUsernameViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.whiteColor()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        title = "sign in"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonPressed:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPressed:")
    }
    
    func setupTableView() {
        self.tableView.registerClass(TextFieldCell.classForCoder(), forCellReuseIdentifier: kTextFieldCellIdentifier)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        let cell: TextFieldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as TextFieldCell
        cell.textField.resignFirstResponder()
        delegate?.chooseUsernameViewControllerDidCancel(self)
    }
    
    func doneButtonPressed(sender: UIBarButtonItem) {
        let cell: TextFieldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as TextFieldCell
        cell.textField.resignFirstResponder()
        delegate?.chooseUsernameViewController(self, didPickUsername: cell.textField.text)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier(kTextFieldCellIdentifier) as? TextFieldCell
        
        if (!cell) {
            cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: kTextFieldCellIdentifier)
        }
        
        cell!.textField.placeholder = "username"
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
