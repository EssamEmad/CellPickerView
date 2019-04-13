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
public class CellPickerView: UIView {
    
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
    var buttonNames:[String] = [String](){
        didSet{
            buttons = [CellButton]()
            for name in buttonNames{
                let button = CellButton()
                button.setTitle(name, for: [.normal])
                buttons?.append(button)
            }
            drawCellButtons(buttons: buttons!)
        }
    }
    @IBInspectable var animationDuration: TimeInterval = 0.5
    @IBInspectable var canSelectMultiple:Bool = false // Set to true if we can select multiple cells at the same time
    @IBInspectable public var unselectedTextColor:UIColor = UIColor.white
    @IBInspectable public var selecedTextColor:UIColor = UIColor.black
    @IBInspectable public var selectedBackgroundColor = UIColor.blue
    @IBInspectable public var unselectedBackgroundStateColor = UIColor.white

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
        cell.isButtonSelected = selected
        func flipState(){
            cell.titleLabel?.textColor = selected ? selecedTextColor : unselectedTextColor
            cell.backgroundColor = selected ? selectedBackgroundColor : unselectedBackgroundStateColor
        }
        if let animation = animation {
            switch animation {
            case .bubble:
                let oldSize = cell.frame.size
                UIView.animate(withDuration: animationDuration,
                                           animations: {
                                            cell.frame.size = CGSize(width: cell.frame.width + cell.frame.width / 10, height: cell.frame.height + cell.frame.height / 10)
                                            flipState()
                                            
                    }, completion: { (_:Bool) in
                        UIView.animate(withDuration: self.animationDuration, animations: {
                            cell.frame.size = oldSize
                        })
                })
            case .opacity:
                UIView.animate(withDuration: animationDuration, animations: {
                    cell.alpha = 0.5
                    flipState()
                    }, completion: { (_:Bool) in
                        UIView.animate(withDuration: self.animationDuration, animations: {
                            cell.alpha = 1.0
                        })
                })
            }

        } else {
            flipState()
        }
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
