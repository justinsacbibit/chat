//
//  TextFieldCell.swift
//  Chat-iOS-Swift
//
//  Created by Justin Sacbibit on 2014-07-28.
//  Copyright (c) 2014 Justin Sacbibit. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    var textField = UITextField()
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.font = FontUtil.helveticaNeueLightFont(16.0)
        contentView.addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 15.0,
            CGRectGetMinY(self.contentView.frame),
            CGRectGetWidth(self.contentView.frame) - 15.0,
            CGRectGetHeight(self.contentView.frame))
    }
}
