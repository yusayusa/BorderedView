//
//  BorderedView.swift
//  BorderedView
//
//  Created by KazukiYusa on 2016/11/13.
//  Copyright © 2016年 KazukiYusa. All rights reserved.
//

import UIKit

// @IBDesignable
open class BorderedView: UIView {
  
  public struct Sides: OptionSet {
    
    public let rawValue: UInt
    public static let allZeros = Sides(rawValue: 0)
    public static let top = Sides(rawValue: 1 << 0)
    public static let right = Sides(rawValue: 1 << 1)
    public static let bottom = Sides(rawValue: 1 << 2)
    public static let left = Sides(rawValue: 1 << 3)
    public static let all: Sides = [.top, .right, .bottom, .left]
    public static let horizontal: Sides = [.left, .right]
    public static let vertical: Sides = [.top, .bottom]
    
    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }
  }
  
  open var sides: Sides = []
  
  @IBInspectable open var topInsets = UIEdgeInsets()
  @IBInspectable open var rightInsets = UIEdgeInsets()
  @IBInspectable open var bottomInsets = UIEdgeInsets()
  @IBInspectable open var leftInsets = UIEdgeInsets()
  
  @IBInspectable open var top: Bool {
    get {
      return self.sides.contains(.top)
    }
    set {
      if newValue == true {
        self.sides.insert(.top)
      } else {
        self.sides.remove(.top)
      }
    }
  }
  
  @IBInspectable open var right: Bool {
    get {
      return self.sides.contains(.right)
    }
    set {
      if newValue == true {
        self.sides.insert(.right)
      } else {
        self.sides.remove(.right)
      }
    }
  }
  
  @IBInspectable open var bottom: Bool {
    get {
      return self.sides.contains(.bottom)
    }
    set {
      if newValue == true {
        self.sides.insert(.bottom)
      } else {
        self.sides.remove(.bottom)
      }
    }
  }
  
  @IBInspectable open var left: Bool {
    get {
      return self.sides.contains(.left)
    }
    set {
      if newValue == true {
        self.sides.insert(.left)
      } else {
        self.sides.remove(.left)
      }
    }
  }
  
  @IBInspectable open var lineWidthPixel: CGFloat = 0
  @IBInspectable open var lineColor: UIColor = UIColor.clear
  
  open override var intrinsicContentSize: CGSize {
    return CGSize(width: 2, height: 2)
  }
  
  open override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    
    if layer != self.layer {
      
      return
    }
    
    let lineWidth = lineWidthPixel / UIScreen.main.scale
    let lineOffset = lineWidth / 2
    let path = UIBezierPath()
    
    if self.top == true {
      
      let y = lineOffset + self.topInsets.top - self.topInsets.bottom
      path.move(to: CGPoint(x: self.topInsets.left, y: y))
      path.addLine(to: CGPoint(x: self.bounds.width - self.topInsets.right, y: y))
    }
    
    if self.left == true {
      
      let x = lineOffset + self.leftInsets.right + self.leftInsets.left
      path.move(to: CGPoint(x: x, y: (0 - lineOffset) + self.leftInsets.top))
      path.addLine(to: CGPoint(x: x, y: (self.bounds.height + lineOffset) - self.leftInsets.bottom))
    }
    
    if self.bottom == true {
      let y = self.bounds.height - lineOffset + self.bottomInsets.top - self.bottomInsets.bottom
      path.move(to: CGPoint(x: self.bottomInsets.left, y: y))
      path.addLine(to: CGPoint(x: self.bounds.width - self.bottomInsets.right, y: y))
    }
    
    if self.right == true {
      
      let x = self.bounds.width - lineOffset - self.rightInsets.right + self.rightInsets.left
      path.move(to: CGPoint(x: x, y: (0 - lineOffset) + self.rightInsets.top))
      path.addLine(to: CGPoint(x: x, y: (self.bounds.height + lineOffset) - self.rightInsets.bottom))
    }
    
    borderLayer.path = path.cgPath
    borderLayer.strokeColor = lineColor.cgColor
    borderLayer.lineWidth = lineWidth
    
    if borderLayer.superlayer == nil {
      self.layer.addSublayer(borderLayer)
    }
  }
  
  fileprivate let borderLayer = CAShapeLayer()
}
