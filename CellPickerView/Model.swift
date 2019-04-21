//
//  Model.swift
//  CellPickerView
//
//  Created by Essam on 4/14/19.
//  Copyright © 2019 Hepta. All rights reserved.
//

import Foundation


open class CellAdapter {
    open var image: UIImage?
    open var label: String?
    public init(){
        
    }
    public init(image: UIImage?, label: String?) {
        self.image = image; self.label = label
    }
}

open class CellPresentationAdapter{
  //TODO Implement
}
