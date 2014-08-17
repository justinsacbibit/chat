//
//  TextInputView.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-29.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

protocol TextInputViewDelegate {
    func textInputViewWillBeginEditing(textInputView: TextInputView)
}

class TextInputView: UIView, UITextViewDelegate {
    var delegate: TextInputViewDelegate?
    
    var textView = UITextView()
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView.delegate = self
        textView.frame = bounds
        addSubview(textView)
    }
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        delegate?.textInputViewWillBeginEditing(self)
        return true
    }
}
