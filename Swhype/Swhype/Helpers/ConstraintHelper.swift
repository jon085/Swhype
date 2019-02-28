//
//  ConstraintHelper.swift
//  Swhype
//
//  Created by Jono on 17.02.19.
//  Copyright © 2019 Jono. All rights reserved.
//

import UIKit

class ConstraintHelper {
    
    private static func allowResize(alterView: inout UIView) {
        alterView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    static func takeOwner(alterView: inout UIView) {
        setLeading(alterView: &alterView)
        setTrailing(alterView: &alterView)
        setYandHeight(alterView: &alterView)
    }
    
    static func setYandHeight(alterView: inout UIView) {
        guard let superview = alterView.superview else { return }
        allowResize(alterView: &alterView)
        
        superview.addConstraint(NSLayoutConstraint(item: alterView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: superview,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 0))
        
        superview.addConstraint(NSLayoutConstraint(item: alterView,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: superview,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
    }
    
    static func setLeading(alterView: inout UIView) {
        guard let superview = alterView.superview else { return }
        allowResize(alterView: &alterView)
        
        superview.addConstraint(NSLayoutConstraint(item: alterView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: superview,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 0))
    }
    
    static func setTrailing(alterView: inout UIView) {
        guard let superview = alterView.superview else { return }
        allowResize(alterView: &alterView)
        
        superview.addConstraint(NSLayoutConstraint(item: alterView,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: superview,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: 0))
    }
    
    static func setLeftTo(alterView: inout UIView, viewOnTheLeft leftView: UIView, centerLeft: Bool = false) {
        guard let superview = alterView.superview else { return }
        allowResize(alterView: &alterView)
        
        superview.addConstraint(NSLayoutConstraint(item: alterView,
                                                   attribute: centerLeft ? .centerX : .left,
                                                   relatedBy: .equal,
                                                   toItem: leftView,
                                                   attribute: .right,
                                                   multiplier: 1,
                                                   constant: 2))
    }
    
    static func setWidth(alterView: inout UIView, value: Float) {
        guard let superview = alterView.superview else { return }
        allowResize(alterView: &alterView)
        
        superview.addConstraint(NSLayoutConstraint(item: alterView,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: superview,
                                                   attribute: .width,
                                                   multiplier: CGFloat(value),
                                                   constant: 0))
    }
}
