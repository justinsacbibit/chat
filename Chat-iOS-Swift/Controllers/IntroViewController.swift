//
//  IntroViewController.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-28.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, ChooseUsernameViewControllerDelegate, ChatViewControllerDelegate {
    var user: User?
    
    var titleLabel: UILabel?
    var imageView: UIImageView?
    var startButton: UIButton?
    var creditLabel: UILabel?
    var loggedInLabel: UILabel?
    var logOutButton: UIButton?
    var logInButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // todo: setup chat service
        
        user = self.loadUser()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let username: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("username") {
            var user = User()
            user.username = username as? String
            var controller = ChatViewController()
            controller.delegate = self
            controller.user = user
            var nav = UINavigationController(rootViewController: controller)
            self.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    func loadUser() -> User? {
        // todo: complete method
        return nil
    }
    
    func setupUI() {
        setupTitleLabel()
        setupImageView()
        setupStartButton()
        setupCreditLabel()
        if user != nil {
            setupLoggedInLabel()
            setupLogOutButton()
        } else {
//            setupLogInButton()
        }
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel(frame: CGRectMake(20.0, 150.0, view.bounds.size.width - 40.0, 40.0))
        titleLabel!.font = FontUtil.helveticaNeueUltraLightFont(40.0)
        titleLabel!.textAlignment = NSTextAlignment.Center
        titleLabel!.text = "chat"
        view.addSubview(titleLabel!)
    }
    
    func setupImageView() {
        imageView = UIImageView(image: UIImage(named: "chat-bubble"))
        imageView!.frame = CGRectMake(titleLabel!.center.x,
            titleLabel!.frame.origin.y - 90.0,
            imageView!.frame.size.width / 3.0,
            imageView!.frame.size.height / 3.0)
        imageView!.center = CGPoint(x: titleLabel!.center.x + 30.0, y: titleLabel!.center.y + 70.0)
        view.insertSubview(imageView!, belowSubview: titleLabel!)
    }
    
    func setupStartButton() {
        if self.user != nil {
            startButton = createButtonWithYCoord(CGRectGetHeight(view.bounds) - 170, title: "enter chat", selector: "enterButtonPressed:")
        } else {
            startButton = createButtonWithYCoord(CGRectGetHeight(view.bounds) - 170, title: "choose username", selector: "chooseUsernameButtonPressed:")
        }
        view.addSubview(startButton!)
    }
    
    func setupCreditLabel() {
        creditLabel = UILabel(frame: CGRectMake(20.0, view.bounds.size.height - 30.0, view.bounds.size.width - 40.0, 20.0))
        creditLabel!.font = FontUtil.helveticaNeueLightFont(12.0)
        creditLabel!.textAlignment = NSTextAlignment.Center
        creditLabel!.text = "Created by Justin Sacbibit"
        view.addSubview(creditLabel!)
    }
    
    func setupLoggedInLabel() {
        loggedInLabel = UILabel(frame: CGRectMake(20.0, CGRectGetMaxY(titleLabel!.frame) + 30.0, view.bounds.size.width - 40.0, 40.0))
        loggedInLabel!.font = FontUtil.helveticaNeueLightFont(25.0)
        loggedInLabel!.textAlignment = NSTextAlignment.Center
        loggedInLabel!.text = String(format: "logged in as %@", user!.username!)
        view.addSubview(loggedInLabel!)
    }
    
    func setupLogOutButton() {
        logOutButton = createButtonWithYCoord(CGRectGetMaxY(startButton!.frame) + 10.0, title: "log out", selector: "logOutButtonPressed:")
    }
    
    func setupLogInButton() {
        logInButton = createButtonWithYCoord(CGRectGetMaxY(startButton!.frame) + 10.0, title: "log in", selector: "logInButtonPressed:")
    }
    
    func createButtonWithFrame(frame: CGRect, title: String, selector: Selector) -> UIButton {
        var button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.titleLabel.font = FontUtil.helveticaNeueLightFont(18.0)
        button.backgroundColor = UIColor.blackColor()
        return button
    }
    
    func createButtonWithYCoord(yCoord: CGFloat, title: String, selector: Selector) -> UIButton {
        let x:CGFloat = 80
        let y:CGFloat = yCoord
        let width:CGFloat = CGRectGetWidth(view.bounds) - 160
        let height:CGFloat = 50
        
        let frame = CGRectMake(x, y, width, height)
        var button = createButtonWithFrame(frame, title: title, selector: selector);
        return button
    }
    
    func chooseUsernameButtonPressed(sender: UIButton!) {
        var controller = ChooseUsernameViewController(style: UITableViewStyle.Grouped)
        controller.delegate = self
        self.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func enterButtonPressed(sender: UIButton!) {
        var controller = ChatViewController()
        controller.user = user
        self.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func logOutButtonPressed(sender: UIButton!) {
        
    }
    
    func logInButtonPressed(sender: UIButton!) {
        
    }
    
    func chooseUsernameViewController(chooseUsernameViewController: ChooseUsernameViewController, didPickUsername username: String?) {
        self.dismissViewControllerAnimated(true) {
            if username == nil || username!.utf16Count <= 0 {
                return
            }
            
            let controller = ChatViewController()
            let user = User()
            user.username = username
            controller.user = user
            controller.delegate = self
            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
            self.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }
    
    func chooseUsernameViewControllerDidCancel(chooseUsernameViewController: ChooseUsernameViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func chatViewControllerDidLogout(chatViewController: ChatViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
    }
}
