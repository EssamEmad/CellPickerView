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
            let color = isSelectedState ? selectedTextColor : unselectedTextColor
            setTitleColor(color, for: .normal)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
    
    func set(title: String?, image: UIImage?){
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        layoutIfNeeded()
        guard let _ = title, let _ = image else {return}
        let spacing:CGFloat = 10
        let imagePercentage:CGFloat = 0.6
        let imageSize = CGSize(width: bounds.width * imagePercentage, height: bounds.height * imagePercentage)
        let titleHeight = titleLabel?.frame.height ?? 0
        let imageRect = CGRect(x: bounds.midX - imageSize.width / 2, y: (bounds.height - spacing - titleHeight - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        titleEdgeInsets = UIEdgeInsets(top: imageRect.maxY + spacing, left: -titleLabel!.frame.maxX, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: imageRect.minY, left: imageRect.minX, bottom: bounds.height - imageRect.maxY, right: imageView!.frame.maxX - imageRect.maxX )
    }
    
    private func setup(){
        adjustsImageWhenHighlighted = false
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .center
    }
}
