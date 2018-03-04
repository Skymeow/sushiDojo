//
//  GameScene.swift
//  rocket
//
//  Created by Sky Xu on 3/1/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var rocket: SKSpriteNode!
    var angle: CGFloat = CGFloat(30/360 * Double.pi)
    var vel: CGFloat = 5
    var rotationV: CGFloat = 5
    var width: CGFloat?
    var height: CGFloat?
    // Make Rocket Sub class
    // Reset the rocket after it leaves the screen
    // make target show up at a random position
    // detect if the rocket hits the target
    // Keep score
    
    override func didMove(to view: SKView) {
        width = self.view?.frame.width
        height = self.view?.frame.height
        makeRocket()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
//       stop rotation when touch
        rotationV = 0
        
    }
    

    override func update(_ currentTime: TimeInterval) {
        //  MARK: reset the rocket back to a new start once it leaves the screen
        resetRocket()
        angle += rotationV/360 * CGFloat(Double.pi)
        
        let dy = sin(angle) * vel
        let dx = cos(angle) * vel
        rocket.position.y += dy
        rocket.position.x += dx
        
        rocket.zRotation = angle
    }
    
    //    create rocket
    func makeRocket() {
        let size = CGSize(width: 50, height: 50)
        let texture = SKTexture(imageNamed: "box")
        rocket = Rocket(texture: texture, color: UIColor.blue, size: size)
        addChild(rocket)
        rocket.position.x = self.size.width / 3
        rocket.position.y = self.size.height / 8
    }
    
    func randomizeStart() -> CGPoint {
        let x = Int(arc4random_uniform(UInt32(self.width!)))
        let y = Int(arc4random_uniform(UInt32(self.height!)))
        let randomPoint = CGPoint(x: x, y: y)
        
        return randomPoint
    }
    
//    reset rocket function
    func resetRocket() {
        if rocket.position.x < 0 || rocket.position.y < 0 || rocket.position.x > width! || rocket.position.y > height! {
            
//            let newPoint = self.randomizeStart()
//            self.rocket.position = newPoint
        }
    }
}
