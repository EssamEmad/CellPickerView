//
//  CellButton.swift
//  CellPickerView
//
//  Created by Essam on 4/25/17.
//  Copyright © 2017 hepta. All rights reserved.
//

import UIKit

class PickerViewCell: UIView {
    
    
    //MARK:- properties
    private var isSelectedState:Bool = false {
        didSet{
            //Change colors
            let color = isSelectedState ? selectedTextColor : unselectedTextColor
            label?.textColor = color
            backgroundColor = isSelectedState ? selectedBackgroundColor : unselectedBackgroundStateColor
        }
    }
    fileprivate var imageView: UIImageView?
    fileprivate var label: UILabel?

    weak var delegate: CellDelegate?
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
                    }, completion: {_ in self.layer.zPosition = 0})
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
            case .noAnimation:
                flipState()
            }
        } else {
            flipState()
        }
    }
    
    @objc func onClick(sender: UITapGestureRecognizer) {
        delegate?.didTap(cell: self)
    }
    func set(title: String?, image: UIImage?){
        
        subviews.forEach {$0.removeFromSuperview()}
        let imageView = image == nil ? nil : UIImageView()
        self.imageView = imageView
        imageView?.contentMode = .scaleAspectFit
        if let image = image {
            let imagePercentage:CGFloat = 0.5
            let imageSize = CGSize(width: bounds.width * imagePercentage, height: bounds.height * imagePercentage)
            let imageRect = CGRect(x: bounds.midX - imageSize.width / 2, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
            imageView!.image = image
            addSubview(imageView!)
            imageView!.frame = imageRect
        }
        
        if let title = title {
            let spacing:CGFloat = 10
            let titleLabel = UILabel()
            self.label = titleLabel
            titleLabel.textAlignment = .center
            titleLabel.text = title
            addSubview(titleLabel)
            let titleHeight:CGFloat = 15
            if let iv = imageView {
                //Move the imageView upwards a bit, then set the title label
                let newImageRect = CGRect(x: iv.frame.minX, y: iv.frame.minY - spacing - titleHeight, width: iv.frame.width, height: iv.frame.height)
                imageView?.frame = newImageRect
                titleLabel.frame = CGRect(x: 0, y: newImageRect.maxY + spacing, width: frame.width, height: titleHeight)
            } else {
                titleLabel.frame = CGRect(x: 0, y: frame.midY - titleHeight / 2, width: frame.width, height: titleHeight)
            }
        }
    }
    
    private func setup(){
        isSelectedState = false
        //Add gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick(sender:)))
        addGestureRecognizer(tap)
    }
}
