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
    case noAnimation
}
open class CellPickerView: UIView, CellDelegate {
    

    
    //MARK:- properties
    private var buttons: [PickerViewCell]? // We keep references to the drawn buttons as they aren't supposed to be plenty

    @IBInspectable public var animationDuration: TimeInterval = Constants.animationDuration ///If selectionAnimation is set to .noAnimation this field is discarded
    @IBInspectable public var canSelectMultiple:Bool = false // Set to true if we can select multiple cells at the same time
    @IBInspectable public var unselectedTextColor:UIColor = Constants.unselectedTextColor
    @IBInspectable public var selectedTextColor:UIColor = Constants.selectedTextColor
    @IBInspectable public var selectedBackgroundColor = Constants.selectedBackgroundColor
    @IBInspectable public var unselectedBackgroundStateColor = Constants.unselectedBackgroundStateColor
    @IBInspectable public var spacing:CGFloat = 0 //Spacing between cells
    public var maxWidth:CGFloat? // If set, the value is going to be used to calculate the width of the cell. Otherwise, the cell is as big as it can get
    @IBInspectable public var cellBorderWidth:CGFloat = 0
    @IBInspectable public var cellBorderColor:CGColor?
    @IBInspectable public var cellCornerRadius:CGFloat = 0
    
    open var selectionAnimation: CellSelectionAnimation = .bubble
    open weak var dataSource: CellPickerViewDatasource? {
        didSet {
            reloadData()
        }
    }
    
    //MARK:- Public API

    open override func awakeFromNib() {
        super.awakeFromNib()
        drawButtons()
        
    }
    open override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        drawButtons()
    }
    /**
     Sets the given cell to the passed selected state
     
     - Parameter index: Index of given cell (0-indexed)
     - Parameter selected: State of selection that is to be applied
     - Parameter animation: The animation for this specific selection. If nil is passed CellPickerView.selectionAnimation will be applied
     */
    public func selectCell(index:Int, isSelected selected: Bool, withAnimation animation: CellSelectionAnimation?) {
        if let cell = buttons?[index]{
            selectCell(cell: cell, isSelected: selected, withAnimation: animation)
        }
    }
    

    func selectCell(cell: PickerViewCell, isSelected selected: Bool, withAnimation animation: CellSelectionAnimation?){
        let selectedCells = getSelected()
        cell.setSelected(selected: selected, withAnimation: animation ?? selectionAnimation, interval: animationDuration, completion: nil)
        if !canSelectMultiple && !selectedCells.isEmpty {
            for index in selectedCells {
                if let c = buttons?[index] {
                    c.setSelected(selected: false, withAnimation: .noAnimation, interval: animationDuration, completion: nil)
                }
            }
        }
    }

    ///- Returns: A list of the indeces of the selected cells (0-indexed)
    func getSelected()->[Int]{
        return buttons?.map{$0.isButtonSelected}.enumerated().filter{$1}.map{$0.offset} ?? []
    }

    open func reloadData(){
        drawButtons()
    }
    
    //MARK:- CellDelegate
    
    func didTap(cell: PickerViewCell) {
        selectCell(cell: cell, isSelected: !cell.isButtonSelected, withAnimation: self.selectionAnimation)
    }
    
    //MARK:- Helpers
    
    /**
     Removes all of the subviews in the pickerview and draws the cells.
     
     Asks the datasource for the data and redraws all of the cellbuttons.
     */
    private func drawButtons(){
        //remove all subviews
        guard let dataSource = dataSource else { return}
        self.subviews.forEach { $0.removeFromSuperview()}
        layoutIfNeeded()
        let count = dataSource.numberOfCells(inPicker: self)
        var totalInterSpacing: CGFloat = 0
        if spacing > 0 {
            if count > 2 {
                totalInterSpacing = CGFloat(count-1) * spacing
            } else if count == 2 {
                totalInterSpacing = spacing
            }
        }
        var width = (frame.width - totalInterSpacing) / CGFloat(count)
        var start:CGFloat = 0
        if let p = maxWidth, width > p {
            width = p
            start = (frame.width - p * CGFloat(count) - totalInterSpacing) / 2
        }
        var oldFrame = CGRect(x: start, y: 0, width: 0, height: frame.height)
        buttons = [PickerViewCell]()
        for i in 0..<count {
            let item = dataSource.cell(forPicker: self, atIndex: i)
            let button = PickerViewCell()
            let xStart = oldFrame.maxX + (i == 0 ? 0 : spacing)
            button.frame = CGRect(x: xStart, y: 0, width: width, height: self.frame.height)
            oldFrame = button.frame
            addSubview(button)
            button.delegate = self
            button.selectedTextColor = selectedTextColor
            button.unselectedTextColor = unselectedTextColor
            button.selectedBackgroundColor = selectedBackgroundColor
            button.unselectedBackgroundStateColor = unselectedBackgroundStateColor
            button.set(title: item.label , image: item.image)
            button.layer.borderColor = cellBorderColor
            button.layer.borderWidth = cellBorderWidth
            button.layer.cornerRadius = cellCornerRadius
            buttons?.append(button)
        }
    }
    
    
}
