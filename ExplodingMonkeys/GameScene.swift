//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by My Nguyen on 8/17/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var buildings = [BuildingNode]()
    // weak reference to the view controller
    weak var viewController: GameViewController!
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var currentPlayer = 1

    override func didMoveToView(view: SKView) {
        // give the scene a dark blue color to represent the night sky
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        // create buildings
        createBuildings()
        // create players
        createPlayers()

        // get notified of collisions
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
        if banana != nil {
            // if banana misses the other player and all the buildings and goes off screen
            if banana.position.y < -1000 {
                // remove the banana
                banana.removeFromParent()
                banana = nil
                // change players
                changePlayer()
            }
        }
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
        // how hard to throw the banana
        let speed = Double(velocity) / 10.0

        // convert the input angle to radians
        let radians = deg2rad(angle)

        // remove any leftover banana
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }

        // create a new banana using circle physics
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody!.categoryBitMask = CollisionTypes.Banana.rawValue
        banana.physicsBody!.collisionBitMask = CollisionTypes.Building.rawValue | CollisionTypes.Player.rawValue
        banana.physicsBody!.contactTestBitMask = CollisionTypes.Building.rawValue | CollisionTypes.Player.rawValue
        banana.physicsBody!.usesPreciseCollisionDetection = true
        addChild(banana)

        if currentPlayer == 1 {
            // player1's banana is positioned up and to the left of player1
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            // give banana some spin
            banana.physicsBody!.angularVelocity = -20

            // animate player1 throwing his arm up and putting it down
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.waitForDuration(0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.runAction(sequence)

            // make the banana move in the right direction
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            // player2's banana is positioned up and to the right of player2
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            // apply the opposite spin
            banana.physicsBody!.angularVelocity = 20

            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.waitForDuration(0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.runAction(sequence)

            // make the banana move in the right direction
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }

    func createPlayers() {
        // create a player
        player1 = SKSpriteNode(imageNamed: "player")
        // name it "player1"
        player1.name = "player1"
        // create player1's physics body, which is circle because the sprite used is almost round
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        // set player1 to collide with banana
        player1.physicsBody!.collisionBitMask = CollisionTypes.Banana.rawValue
        player1.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
        // set player1 to stationary
        player1.physicsBody!.dynamic = false

        // place player1 at the top of the second building in the buildings array
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        // add player1 to the scene
        addChild(player1)

        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player2.physicsBody!.collisionBitMask = CollisionTypes.Banana.rawValue
        player2.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
        player2.physicsBody!.dynamic = false

        // place player2 at the top of the second to last building in the array
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }

    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * M_PI / 180.0
    }

    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        // set the first body to the lower CollisionType and the second body to the higher CollisionType
        // this will eliminate half of whether "banana hit building" or "building hit banana"
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        // unwrap both bodies, since they might be nil
        if let firstNode = firstBody.node {
            if let secondNode = secondBody.node {
                // a banana hit a building
                if firstNode.name == "banana" && secondNode.name == "building" {
                    bananaHitBuilding(secondNode as! BuildingNode, atPoint: contact.contactPoint)
                }

                // a banana hit a player
                if firstNode.name == "banana" && secondNode.name == "player1" {
                    destroyPlayer(player1)
                }

                if firstNode.name == "banana" && secondNode.name == "player2" {
                    destroyPlayer(player2)
                }
            }
        }
    }

    func destroyPlayer(player: SKSpriteNode) {
        // place an explosion at player's position
        let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
        explosion.position = player.position
        addChild(explosion)

        // remove both player and banana from the scene
        player.removeFromParent()
        banana?.removeFromParent()

        // pause for 2 seconds so the player can see who won the game
        RunAfterDelay(2) { [unowned self] in
            // create a new scene
            let newGame = GameScene(size: self.size)
            // set the new scene's viewController property and update the view controller's currentGame property
            // so they can talk to each other once the change has occurred
            newGame.viewController = self.viewController
            self.viewController.currentGame = newGame

            // transfer control of the game to the other player
            self.changePlayer()
            // set the new game's currentPlayer property to this currentPlayer property,
            // so this player will be next after the other player dies
            newGame.currentPlayer = self.currentPlayer

            // create a transition to the new scene and cross-fade to the scene over 1.5 seconds
            let transition = SKTransition.doorwayWithDuration(1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }

    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }

        viewController.activatePlayerNumber(currentPlayer)
    }

    func bananaHitBuilding(building: BuildingNode, atPoint contactPoint: CGPoint) {
        // convert the collision contact point to the coordinates relative to the building node
        let buildingLocation = convertPoint(contactPoint, toNode: building)
        // damage the building
        building.hitAtPoint(buildingLocation)

        // create an explosion
        let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
        explosion.position = contactPoint
        addChild(explosion)

        // delete the banana
        banana.name = ""
        banana?.removeFromParent()
        banana = nil

        // change the player
        changePlayer()
    }
}
