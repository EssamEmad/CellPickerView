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
    private var isSelectedState:Bool = false {
        didSet{
            //Change colors
            titleLabel?.textColor = isSelectedState ? selectedTextColor : unselectedTextColor
            backgroundColor = isSelectedState ? selectedBackgroundColor : unselectedBackgroundStateColor
        }
    }
    
    var unselectedTextColor:UIColor = Constants.unselectedTextColor
    var selectedTextColor:UIColor = Constants.selectedTextColor
    var selectedBackgroundColor = Constants.selectedBackgroundColor
    var unselectedBackgroundStateColor = Constants.unselectedBackgroundStateColor
    
    var isButtonSelected:Bool {
        return isSelectedState
    }
    
    func setSelected(selected: Bool){
        setSelected(selected: selected, withAnimation: nil, interval: nil, completion: nil)
    }
    func setSelected(selected:Bool, withAnimation animation: CellSelectionAnimation?, interval: TimeInterval?, completion: (()->())?) {
        func flipState(){
            self.isSelectedState = selected
        }
        if selected == self.isSelectedState {
            return
        }
        let interval = interval ?? 0.2
        if let animation = animation {
            switch animation {
            case .bubble:
                UIView.animate(withDuration: interval,
                               animations: {
                                self.layer.zPosition = 1
                                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                flipState()
                                
                }, completion: { (_:Bool) in
                    UIView.animate(withDuration: interval, animations: {
                        self.transform = CGAffineTransform.identity
                    })
                })
            case .opacity:
                UIView.animate(withDuration: interval, animations: {
                    self.alpha = 0.5
                    flipState()
                }, completion: { (_:Bool) in
                    UIView.animate(withDuration: interval, animations: {
                        self.alpha = 1.0
                    })
                })
            }
        }
    }
}
