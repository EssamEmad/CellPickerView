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
    @IBInspectable public var animationDuration: TimeInterval = Constants.animationDuration
    @IBInspectable public var canSelectMultiple:Bool = false // Set to true if we can select multiple cells at the same time
    @IBInspectable public var unselectedTextColor:UIColor = Constants.unselectedTextColor
    @IBInspectable public var selectedTextColor:UIColor = Constants.selectedTextColor
    @IBInspectable public var selectedBackgroundColor = Constants.selectedBackgroundColor
    @IBInspectable public var unselectedBackgroundStateColor = Constants.unselectedBackgroundStateColor
    @IBInspectable public var multiLine:Bool = false
    
    public var preferredWidth:CGFloat? // If set, the value is going to be used to calculate the width of the cell. Otherwise, the cell is as big as it can get
    
    open var selectionAnimation: CellSelectionAnimation = .bubble
    open weak var dataSource: CellPickerViewDatasource? {
        didSet {
            drawButtons()
        }
    }
    private var collectionView: UICollectionView!
    
    //MARK:- Public API

    open override func awakeFromNib() {
        super.awakeFromNib()
        drawButtons()
        
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
    
    private func drawButtons(){
        //remove all subviews
        guard let dataSource = dataSource else { return}
        self.subviews.forEach { $0.removeFromSuperview()}
        layoutIfNeeded()
        let count = dataSource.numberOfCells(inPicker: self)
        var width = frame.width / CGFloat(count)
        if let p = preferredWidth, width > p {
            width = p
        }
        var oldFrame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        for i in 0..<count {
            let item = dataSource.cell(forPicker: self, atIndex: i)
            let button = CellButton()
            button.frame = CGRect(x: oldFrame.maxX, y: 0, width: width, height: self.frame.height)
            oldFrame = button.frame
            addSubview(button)
            button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
            button.set(title: item.label , image: item.image)
            
        }
    }
    
    
}
