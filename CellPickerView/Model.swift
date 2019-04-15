//
//  Model.swift
//  CellPickerView
//
//  Created by Essam on 4/14/19.
//  Copyright © 2019 Hepta. All rights reserved.
//

import Foundation


open class CellAdapter {
    var image: UIImage?
    var label: String?
    public init(image: UIImage?, label: String?) {
        self.image = image; self.label = label
    }
}

open class CellPresentationAdapter{
    
}
