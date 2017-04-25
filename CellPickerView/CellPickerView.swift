//
//  CellPickerView.swift
//  CellPickerView
//
//  Created by Essam on 4/25/17.
//  Copyright © 2017 hepta. All rights reserved.
//

import UIKit

enum CellSelectionAnimation{
    case opacity
    case zoom
}
class CellPickerView: UIView {
    
    //MARK:- properties
    var buttons: [CellButton]? {
        didSet{
            //remove all subviews
            self.subviews.forEach { $0.removeFromSuperview()}
            if let buttons = buttons {
                let buttonWidth = self.frame.width / CGFloat(buttons.count)
                var oldFrame = CGRect(x: 0, y: 0, width: 0, height: self.frame.height)
                for button in buttons{
                    button.frame = CGRect(x: oldFrame.maxX, y: 0, width: buttonWidth, height: self.frame.height)
                    oldFrame = button.frame
                    button.addTarget(self, action: #selector(onButtonClicked), forControlEvents: .TouchUpInside)
                    self.addSubview(button)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        checkNibSubviews()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    private var selectedButton: CellButton?{
        willSet{
            //Deselect the older one
            selectedButton?.isButtonSelected = false
            newValue?.isButtonSelected = true
            self.selectedButton = newValue
        }
        
    }
    
    @IBInspectable var canSelectMultiple:Bool = false // Set to true if we can select multiple cells at the same time
    
    //MARK:- Public API
    
    func selectCell(index:Int, withAnimation animation: CellSelectionAnimation?) {
        if let cell = buttons?[index]{
            selectCell(cell, withAnimation: animation)
        }
    }
    func selectCell(cell: CellButton, withAnimation animation: CellSelectionAnimation?){
        
    }
    
    //MARK:- Actions
    func onButtonClicked(sender: CellButton){
        sender.isButtonSelected = !sender.isButtonSelected
        if !canSelectMultiple {
            self.selectedButton = sender
        }
    }
    
    //MARK:- Private helpers
    //Checks if the client has added Cell buttons in storyboard
    private func checkNibSubviews(){
        
    }
    
}
