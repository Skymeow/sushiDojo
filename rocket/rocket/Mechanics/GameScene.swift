//
//  GameScene.swift
//  rocket
//
//  Created by Sky Xu on 3/1/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

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
    var followPath: SKAction?
    
    var pathSprite = SKShapeNode()
//    make path
//    make rocket to folllow path
    
    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        width = self.view?.frame.width
        height = self.view?.frame.height
        
        makeRocket()
    
        makeTargets(num: 5)
        moveRocket()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
//       stop rotation when touch
        let r = rocket.zRotation
        rocket.removeAllActions()
        let targetx = cos(r) * 300
        let targety = sin(r) * 300
        let vector = CGVector(dx: targetx, dy: targety)
        let launch = SKAction.move(by: vector, duration: 3)
        rocket.run(launch)
    }
    
    func makePath() -> UIBezierPath {
        let width = frame.size.width
        let height = frame.size.height
//        make points
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: width * 0.66, y: height * 0.33)
        let point3 = CGPoint(x: width * 0.33, y: height * 0.66)
        let point4 = CGPoint(x: width, y: height)
        
        let control1 = CGPoint(x: width * 0.1, y: height * 0.33)
        let control2 = CGPoint(x: width * 0.45, y: height * 0.1)
        let control3 = CGPoint(x: width * 0.9, y: height * 0.55)
        let control4 = CGPoint(x: width * 0.25, y: height * 0.65)
        let control5 = CGPoint(x: width * 0.40, y: height * 0.66)
        let control6 = CGPoint(x: width * 0.85, y: height * 0.75)
        let path = UIBezierPath()
        
        path.move(to: point1)
        path.addCurve(to: point2, controlPoint1: control1, controlPoint2: control2)
        path.addCurve(to: point3, controlPoint1: control3, controlPoint2: control4)
        path.addCurve(to: point4, controlPoint1: control5, controlPoint2: control6)
        
        pathSprite.path = path.cgPath
        addChild(pathSprite)
        pathSprite.strokeColor = UIColor.red
        pathSprite.lineWidth = 4
        
        return path
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
//        angle += rotationV/360 * CGFloat(Double.pi)
//
//        let dy = sin(angle) * vel
//        let dx = cos(angle) * vel
//        rocket.position.y += dy
//        rocket.position.x += dx
//
//        rocket.zRotation = angle
//        //  MARK: reset the rocket back to a new start once it leaves the screen
//        resetRocket()
    }
    
    func moveRocket() {
        let path = makePath()
        followPath = SKAction.follow(path.cgPath, speed: 25)
        rocket.run(followPath!)
    }
    
    //    create rocket
    func makeRocket() {
        let texture = SKTexture(imageNamed: "box")
        let size = texture.size()
        let textureWidth = size.width * 0.5
        let textureHeight = size.height * 0.5
        
        rocket = Rocket(texture: texture, color: UIColor.red, size: CGSize(width: textureWidth, height: textureHeight))
        addChild(rocket)
        rocket.position.x = self.size.width / 3
        rocket.position.y = self.size.height / 8
        
        rocket.physicsBody = SKPhysicsBody(circleOfRadius: textureWidth * 0.5)
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
