//
//  BuildingNode.swift
//  ExplodingMonkeys
//
//  Created by My Nguyen on 8/18/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case Banana = 1
    case Building = 2
    case Player = 4
}

class BuildingNode: SKSpriteNode {

    var currentImage: UIImage!

    // make a building by setting its name, texture and physics
    // this method is a hack in lieu of the initializer
    func setup() {
        // set its name
        name = "building"
        // draw the building
        currentImage = drawBuilding(size)
        // set its texture
        texture = SKTexture(image: currentImage)
        // set its physics
        configurePhysics()
    }

    // set up per-pixel physics for the sprite's current texture
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionTypes.Building.rawValue
        physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
    }

    func drawBuilding(size: CGSize) -> UIImage {
        // create a new Core Graphics context the size of the building
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        // fill the context with a rectangle that's one of three colors
        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var color: UIColor

        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
        case 0:
            color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
        case 1:
            color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
        default:
            color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
        }

        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddRect(context, rectangle)
        CGContextDrawPath(context, .Fill)

        // draw windows all over the building in one of two colors: yellow or gray
        let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
        let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)

        // the stride() method loops from one number to another with an interval
        // place windows vertically across the whole height of the building, starting from 10
        // so it will go 10, 50, 90, 130, and so on
        for row in 10.stride(to: Int(size.height - 10), by: 40) {
            // place windows from the left edge of the building to the right edge
            // also, indent the left and right edges by 10 points
            for col in 10.stride(to: Int(size.width - 10), by: 40) {
                if RandomInt(min: 0, max: 1) == 0 {
                    CGContextSetFillColorWithColor(context, lightOnColor.CGColor)
                } else {
                    CGContextSetFillColorWithColor(context, lightOffColor.CGColor)
                }

                CGContextFillRect(context, CGRect(x: col, y: row, width: 15, height: 20))
            }
        }

        // fetch the UIImage result
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
    }
}
