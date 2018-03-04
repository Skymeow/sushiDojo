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
    
    // Make Rocket Sub class
    // Reset the rocket after it leaves the screen
    // make target show up at a random position
    // detect if the rocket hits the target
    // Keep score
    
    override func didMove(to view: SKView) {
        makeRocket()
        
    }
//    create rocket
    func makeRocket() {
        let size = CGSize(width: 50, height: 50)
        let texture = SKTexture(imageNamed: "box")
        rocket = Rocket(texture: texture, color: UIColor.blue, size: size)
        addChild(rocket)
        rocket.position.x = self.size.width / 2
        rocket.position.y = self.size.height / 5
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
//       stop rotation when touch
        rotationV = 0
        
    }
    

    override func update(_ currentTime: TimeInterval) {
        angle += rotationV/360 * CGFloat(Double.pi) //
        
        let dy = sin(angle) * vel
        let dx = cos(angle) * vel
        rocket.position.y += dy
        rocket.position.x += dx
        
        rocket.zRotation = angle
        // print(sin(angle), cos(angle))
    }
}
