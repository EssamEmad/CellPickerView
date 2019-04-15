//
//  Protocols.swift
//  CellPickerView
//
//  Created by Essam on 4/25/17.
//  Copyright © 2017 hepta. All rights reserved.
//

import Foundation

public protocol CellPickerViewDatasource: AnyObject{
    func numberOfCells(inPicker picker:CellPickerView)->Int
    func cell(forPicker picker: CellPickerView, atIndex index: Int)->CellAdapter
}
