// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

class CoolViewCell: UIView
{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let currLocation = touch.location(in: nil)
        let prevLocation = touch.previousLocation(in: nil)
        
        let dx = currLocation.x - prevLocation.x
        let dy = currLocation.y - prevLocation.y
        
        frame = frame.offsetBy(dx: dx, dy: dy)
    }
}
