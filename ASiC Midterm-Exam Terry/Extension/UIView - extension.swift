//
//  UIView - extension.swift
//  ASiC Midterm-Exam Terry
//
//  Created by 黃偉勛 Terry on 2019/3/29.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

@IBDesignable

extension UIView {
    
    // Border Color
    
    @IBInspectable var borderColor: UIColor? {
        
        get {
            
            guard let borderColor = layer.borderColor else { return nil }
            
            return UIColor(cgColor: borderColor)
            
        }
        
        set {
            
            layer.borderColor = newValue?.cgColor
            
        }
        
    }
    
    // Border Width
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            
            return layer.borderWidth
            
        }
        
        set {
            
            layer.borderWidth = newValue
            
        }
        
    }
    
    // Corner Radius
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            
            return layer.cornerRadius
            
        }
        
        set {
            
            layer.cornerRadius = newValue
            
        }
        
    }
    
    @IBInspectable var t_zPosition: CGFloat {
        
        get {
            
            return layer.zPosition
            
        }
        
        set {
            
            layer.zPosition = newValue
            
        }
        
    }
    
}

extension UIImage {
    
    @IBInspectable var changeImageColor: Bool {
        
        get {
            
            if self.renderingMode == .alwaysTemplate {
                
                return true
                
            } else {
                
                return false
                
            }
            
        }
        
        set {
            
            if newValue {
                
                self.withRenderingMode(.alwaysTemplate)
                
            }
            
        }
        
    }
    
}
