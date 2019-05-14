// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

private let textInsets = UIEdgeInsets(top: 7, left: 12, bottom: 8, right: 12)

private let textAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.boldSystemFont(ofSize: 20),
    .foregroundColor: UIColor.white
]

extension UIEdgeInsets
{
    var origin: CGPoint { return CGPoint(x: left, y: top) }
    var width: CGFloat { return left + right }
    var height: CGFloat { return top + bottom }
}

class CoolViewCell: UIView
{
    var highlighted = false {
        didSet { alpha = highlighted ? 0.5 : 1.0 }
    }
    
    var text: String? {
        didSet { sizeToFit() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        // FIXME: Don't crash
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Drawing and resizing

extension CoolViewCell
{
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let text = text else { return size }
        var newSize = (text as NSString).size(withAttributes: textAttributes)
        newSize.width += textInsets.width
        newSize.height += textInsets.height
        return newSize
    }
    
    override func draw(_ rect: CGRect) {
        guard let text = text else { return }
        (text as NSString).draw(at: textInsets.origin, withAttributes: textAttributes)
    }
}


// MARK: - UIResponder methods

extension CoolViewCell
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.bringSubviewToFront(self)
        highlighted = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let currLocation = touch.location(in: nil)
        let prevLocation = touch.previousLocation(in: nil)
        
        center.x += currLocation.x - prevLocation.x
        center.y += currLocation.y - prevLocation.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlighted = false
    }
}
