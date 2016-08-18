//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by My Nguyen on 8/17/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // strong reference to the game scene
    var currentGame: GameScene!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var playerNumber: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // load up default values for the two sliders
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)

            // obtain a reference to the game scene
            currentGame = scene
            // make sure the game scene knows about the view controller
            scene.viewController = self
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func angleChanged(sender: AnyObject) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }

    @IBAction func velocityChanged(sender: AnyObject) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }

    @IBAction func launch(sender: AnyObject) {
        // hide all the controls so the user can't try to fire again until it's ready
        angleSlider.hidden = true
        angleLabel.hidden = true
        velocitySlider.hidden = true
        velocityLabel.hidden = true
        launchButton.hidden = true

        // have the game scene launch a balana using the current angle and velocity
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }

    // this method will be called from the game scene when control should pass to the other player
    func activatePlayerNumber(number: Int) {
        // update the player label to reflect who is in control
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }

        // show all the controls again
        angleSlider.hidden = false
        angleLabel.hidden = false
        velocitySlider.hidden = false
        velocityLabel.hidden = false
        launchButton.hidden = false
    }
}
