//
//  CellPickerView.swift
//  CellPickerView
//
//  Created by Essam on 4/25/17.
//  Copyright © 2017 hepta. All rights reserved.
//

import UIKit

@objc public enum CellSelectionAnimation: Int{
    case opacity
    case bubble
}
open class CellPickerView: UIView {
    
    //MARK:- properties
    private var buttons: [CellButton]?
    
    
    private var selectedButton: CellButton?{
        //We deselect the previously selected button if we can't select more than one button and the newly selected button is not the same as the old one
        willSet{
            if let old = selectedButton {
                if !canSelectMultiple && old != newValue{
                    //Deselect the older one
                    selectCell(cell: old, isSelected: false, withAnimation: nil)
                }
            }
        }
        
    }
    
    //Set this property to draw the buttons
    public var buttonNames:[String] = [String](){
        didSet{
            buttons = [CellButton]()
            for name in buttonNames{
                let button = CellButton()
                button.selectedTextColor = selectedTextColor
                button.unselectedTextColor = unselectedTextColor
                button.selectedBackgroundColor = selectedBackgroundColor
                button.unselectedBackgroundStateColor = unselectedBackgroundStateColor
                button.setTitle(name, for: [.normal])
                buttons?.append(button)
            }
            drawCellButtons(buttons: buttons!)
        }
    }
    @IBInspectable public var animationDuration: TimeInterval = Constants.animationDuration
    @IBInspectable public var canSelectMultiple:Bool = false // Set to true if we can select multiple cells at the same time
    @IBInspectable public var unselectedTextColor:UIColor = Constants.unselectedTextColor
    @IBInspectable public var selectedTextColor:UIColor = Constants.selectedTextColor
    @IBInspectable public var selectedBackgroundColor = Constants.selectedBackgroundColor
    @IBInspectable public var unselectedBackgroundStateColor = Constants.unselectedBackgroundStateColor

    public var selectionAnimation: CellSelectionAnimation = .bubble
    
    //MARK:- Public API
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func selectCell(index:Int, isSelected selected: Bool, withAnimation animation: CellSelectionAnimation?) {
        if let cell = buttons?[index]{
            selectCell(cell: cell, isSelected: selected, withAnimation: animation)
        }
    }
    
    //Sending an animation as a parameter instead of nil will override the default animation
    func selectCell(cell: CellButton, isSelected selected: Bool, withAnimation animation: CellSelectionAnimation?){
        selectedButton = cell
        func flipState(){
            
        }
        cell.setSelected(selected: selected, withAnimation: animation, interval: animationDuration, completion: nil)

    }


    //MARK:- Actions
    @objc func onButtonClicked(sender: CellButton){
        selectCell(cell: sender, isSelected: !sender.isButtonSelected, withAnimation: self.selectionAnimation)
        
        
    }
    
    //MARK:- Helpers
    
    private func drawCellButtons(buttons: [CellButton]){
        //remove all subviews
        self.subviews.forEach { $0.removeFromSuperview()}
        let buttonWidth = self.frame.width / CGFloat(buttons.count)
        var oldFrame = CGRect(x: 0, y: 0, width: 0, height: self.frame.height)
        for button in buttons{
            button.frame = CGRect(x: oldFrame.maxX, y: 0, width: buttonWidth, height: self.frame.height)
            button.titleLabel?.textColor = unselectedTextColor
            button.backgroundColor = unselectedBackgroundStateColor
            oldFrame = button.frame
            button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
            self.addSubview(button)
            
        }
    }
    
    
}
