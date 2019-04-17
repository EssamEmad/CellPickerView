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
    
    
    
    //Set this property to draw the buttons
    @IBInspectable public var animationDuration: TimeInterval = Constants.animationDuration
    @IBInspectable public var canSelectMultiple:Bool = false // Set to true if we can select multiple cells at the same time
    @IBInspectable public var unselectedTextColor:UIColor = Constants.unselectedTextColor
    @IBInspectable public var selectedTextColor:UIColor = Constants.selectedTextColor
    @IBInspectable public var selectedBackgroundColor = Constants.selectedBackgroundColor
    @IBInspectable public var unselectedBackgroundStateColor = Constants.unselectedBackgroundStateColor
    @IBInspectable public var spacing:CGFloat = 10 //Spacing between cells
    public var maxWidth:CGFloat? // If set, the value is going to be used to calculate the width of the cell. Otherwise, the cell is as big as it can get
    
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
        cell.setSelected(selected: selected, withAnimation: animation, interval: animationDuration, completion: nil)
    }

    func getSelected()->[Int]{
        return buttons?.map{$0.isButtonSelected}.enumerated().filter{$1}.map{$0.offset} ?? []
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
        var totalInterSpacing: CGFloat = 0
        if spacing > 0 {
            if count > 2 {
                totalInterSpacing = CGFloat(count-2) * spacing
            } else if count == 2 {
                totalInterSpacing = spacing
            }
        }
        var width = (frame.width - totalInterSpacing) / CGFloat(count)
        if let p = maxWidth, width > p {
            width = p
        }
        var oldFrame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        buttons = [CellButton]()
        for i in 0..<count {
            let item = dataSource.cell(forPicker: self, atIndex: i)
            let button = CellButton()
            let xStart = oldFrame.maxX + (i == 0 ? 0 : spacing)
            button.frame = CGRect(x: xStart, y: 0, width: width, height: self.frame.height)
            oldFrame = button.frame
            addSubview(button)
            button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
            button.set(title: item.label , image: item.image)
            buttons?.append(button)
        }
    }
    
    
}
