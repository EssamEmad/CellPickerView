//
//  CellButton.swift
//  CellPickerView
//
//  Created by Essam on 4/25/17.
//  Copyright © 2017 hepta. All rights reserved.
//

import UIKit

class CellButton: UIButton {
    
    
    //MARK:- properties
    var isButtonSelected:Bool = false{
        didSet{
            self.backgroundColor = isButtonSelected ? selectedStateColor : unselectedStateColor
        }
    }
    
    @IBInspectable var selectedStateColor = UIColor.blueColor()
    @IBInspectable var unselectedStateColor = UIColor.whiteColor()    
    
}
