//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by My Nguyen on 8/17/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var buildings = [BuildingNode]()
    // weak reference to the view controller
    weak var viewController: GameViewController!

    override func didMoveToView(view: SKView) {
        // give the scene a dark blue color to represent the night sky
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        // create buildings
        createBuildings()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func createBuildings() {
        // the first building starts before the left edge
        var currentX: CGFloat = -15

        // make buildings horizontally across the scene from the left to the right edges
        while currentX < 1024 {
            // width is 80, 120 or 160 points, all divisible by 40, to simplify the window-drawing code
            let width = RandomInt(min: 2, max: 4) * 40
            // height is anything between 300 and 600 points
            let height = RandomInt(min: 300, max: 600)
            let size = CGSize(width: width, height: height)
            // gap of 2 points between buildings
            currentX += size.width + 2

            // begin building with a solid red color
            let building = BuildingNode(color: UIColor.redColor(), size: size)
            // adjust building's position because SpriteKit places nodes based on their center
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)

            buildings.append(building)
        }
    }

    func launch(angle angle: Int, velocity: Int) {
        
    }
}
