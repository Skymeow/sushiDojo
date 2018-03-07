//
//  GameScene.swift
//  rocket
//
//  Created by Sky Xu on 3/1/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case title, ready, playing, gameOver
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var rocket: SKSpriteNode!
    var angle: CGFloat = CGFloat(30/360 * Double.pi)
    var vel: CGFloat = 5
    var rotationV: CGFloat = 5
    var width: CGFloat?
    var height: CGFloat?
    var targets = [Target]()
    var state: GameState = .title
    // Reset the rocket after it leaves the screen
    // make target show up at a random position
    // detect if the rocket hits the target
    // Keep score
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        width = self.view?.frame.width
        height = self.view?.frame.height
        makeRocket()
        makeTargets(num: 5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
//       stop rotation when touch
        rotationV = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch collision {
        case Category.rocket | Category.planet:
            let emitter = SKEmitterNode(fileNamed: "FireFlies")!
            rocket.addChild(emitter)
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let disappear = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, disappear])
            rocket.run(sequence)
        default:
            return
        }
    }

    override func update(_ currentTime: TimeInterval) {
        angle += rotationV/360 * CGFloat(Double.pi)
        
        let dy = sin(angle) * vel
        let dx = cos(angle) * vel
        rocket.position.y += dy
        rocket.position.x += dx
        
        rocket.zRotation = angle
        //  MARK: reset the rocket back to a new start once it leaves the screen
        resetRocket()
    }
    
    //    create rocket
    func makeRocket() {
        let size = CGSize(width: 20, height: 45)
        let texture = SKTexture(imageNamed: "box")
        rocket = Rocket(texture: texture, color: UIColor.red, size: size)
        addChild(rocket)
        rocket.position.x = self.size.width / 3
        rocket.position.y = self.size.height / 8
        
        rocket.physicsBody = SKPhysicsBody(rectangleOf: size)
        rocket.physicsBody?.contactTestBitMask = Category.rocket | Category.planet
        rocket.physicsBody?.categoryBitMask = Category.rocket
        rocket.physicsBody?.collisionBitMask = Category.none
    }
    
//    make targets
    func makeTargets(num: Int) {
        let size = CGSize(width: 45, height: 45)
        let texture = SKTexture(imageNamed: "target")
        
        let positions = generateMutiTarget(num: num)
        for position in positions {
            let target = Target(texture: texture, color: UIColor.blue, size: size)
            target.position = position
            addChild(target)
            target.physicsBody = SKPhysicsBody(rectangleOf: size)
            target.physicsBody?.contactTestBitMask = Category.rocket | Category.planet
            target.physicsBody?.categoryBitMask = Category.planet
            target.physicsBody?.collisionBitMask = Category.none
        }
    }
    
    func randomizeStart() -> CGPoint {
        let x = Int(arc4random_uniform(UInt32(self.width!)))
        let y = Int(arc4random_uniform(UInt32(self.height!)))
        let randomPoint = CGPoint(x: x, y: y)
        
        return randomPoint
    }
    
    func generateMutiTarget(num: Int) -> [CGPoint] {
        var targetArr = [CGPoint]()
        for _ in 1 ..< (num + 1) {
            let target = randomizeStart()
            targetArr.append(target)
        }
        
        return targetArr
    }
    
//    reset rocket function
    func resetRocket() {
        if rocket.position.x < 0 || rocket.position.y < 0 || rocket.position.x > width! || rocket.position.y > height! {
            state = .gameOver
            gameOver()
            self.rocket.removeFromParent()
//            let newPoint = self.randomizeStart()
//            self.rocket.position = newPoint
        }
    }
    
    func gameOver() {
        
        let skView = self.view as SKView!
        guard let scene = GameScene(fileNamed: "GameScene") as! GameScene! else { return }
        scene.scaleMode = .aspectFill
        skView?.presentScene(scene)
    }
    
    func detectIfHit() {
        
    }
}
