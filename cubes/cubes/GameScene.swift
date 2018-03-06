//
//  GameScene.swift
//  cubes
//
//  Created by Sky Xu on 2/22/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var start: CGPoint?
    var horizontalStart: CGPoint?
    var player: SKSpriteNode!
    var coin: SKSpriteNode!
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch collision {
        case Category.car | Category.player:
            let emitter = SKEmitterNode(fileNamed: "ParticleCollision")!
            player.addChild(emitter)
            
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let disappear = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, disappear])
            player.run(sequence)
            
        case Category.player | Category.coin:
            coin.removeFromParent()
            player.addChild(coin)
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let disappear = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, disappear])
            coin.run(sequence)
            
        default:
            return
        }
    }
//    like viewdidappear (life cycle method)
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero

        makeBoard(3, 3)
        movePlayer()
        makePlayer()
        makeCoin()
        let wait = SKAction.wait(forDuration: 1)
        let spawnEnemy = SKAction.run {
            self.generateStart { (success) in
                // horizontal = true or false
                // starts on the left/top or the right/bottom
                // generate Box
                // if score is > big number then
                // generate a box ! horizontal
                self.start = self.startPoints[Int(arc4random_uniform(UInt32(self.startPoints.count)))]
                var madeBox = self.makeBox(self.start!.x, self.start!.y)
                self.moveBoxVertical(a: madeBox)
                
                self.horizontalStart = self.startPointsH[Int(arc4random_uniform(UInt32(self.startPointsH.count)))]
                var madeBox2 = self.makeBox(self.horizontalStart!.x, self.horizontalStart!.y)
                self.moveBoxHorizontal(a: madeBox2)
                
                
            }
            
        }
        
        
        let sequence = SKAction.sequence([wait, spawnEnemy])
        let timerAction = SKAction.repeatForever(sequence)
        self.run(timerAction)
    }

    @objc func swiped(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .up:
            player.position.y += 65
        case .down:
            player.position.y -= 65
        case .left:
            player.position.x -= 65
        case .right:
            player.position.x += 65
        default:
            return
        }
        
    }
    
    
    func movePlayer() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
    }
    
// make boxes that moves across screen
    func makeBox(_ startX: CGFloat,_ startY: CGFloat) -> SKSpriteNode {
        let color = UIColor.black
        let size = CGSize(width: 40, height: 40)
        let box = SKSpriteNode(color: color, size: size)
        addChild(box)
        
        box.position.x = startX
        box.position.y = startY
        
        box.physicsBody = SKPhysicsBody(rectangleOf: size)
        box.physicsBody?.categoryBitMask = Category.car
        box.physicsBody?.contactTestBitMask = Category.player
        box.physicsBody?.collisionBitMask = Category.none /// 0
        
        return box
        
    }
    
//    function that moves the box
    func moveBoxHorizontal(a: SKSpriteNode) {
        let point = CGPoint(x: frame.width + 20, y: a.position.y)
        let move = SKAction.move(to: point, duration: 3)
        let delete = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, delete])
        a.run(sequence)
    }
    
//    create another function to remove the move action in a sequence
    func moveBoxVertical(a: SKSpriteNode) {
        let point = CGPoint(x: a.position.x, y: self.size.height + 20)
        let move = SKAction.move(to: point, duration: 3)
        let delete = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, delete])
        a.run(sequence)
    }
    
//    make start and end point (array)
    var startPoints = [CGPoint]()
    var startPointsH = [CGPoint]()
    func generateStart(completion: @escaping (Bool) -> Void) {
       
        
        let screenW = self.size.width
        let screenH = self.size.height

        for i in -1 ... 1 {
            let x = CGFloat(screenW / 2) + (65 * CGFloat(i))
            let y = CGFloat(-10)
            let y2 = CGFloat(screenH / 2) + (65 * CGFloat(i))
            let x2 = CGFloat(10)
//
            let point1 = CGPoint(x: x, y: y)
            let point2 = CGPoint(x: x2, y: y2)
            startPoints.append(point1)
            startPointsH.append(point2)
        }
        completion(true)
    }
    
    func makePlayer() {
        let color = UIColor.red
        let size = CGSize(width: 40, height: 40)
        let box = SKSpriteNode(color: color, size: size)
        addChild(box)
        
        box.position.x = 200
        box.position.y = 200
        player = box
        
        //    MARK:  trigger the delegate
        
//        attaching physics to the player
        player.physicsBody = SKPhysicsBody(rectangleOf: size)
//        set category to be the category we defined
        player.physicsBody?.categoryBitMask = Category.player
//        set up contact
        player.physicsBody?.contactTestBitMask = Category.car | Category.coin
//        reset player not be collised with other object, caz we have 3s fadeout
        player.physicsBody?.collisionBitMask = Category.none
    }
    
    func makeCoin() {
        let xArr: [CGFloat] = [142, 207, 272]
        let yArr: [CGFloat] = [303, 368, 433]
        let pointx = xArr[Int(arc4random_uniform(UInt32(xArr.count)))]
        let pointy = yArr[Int(arc4random_uniform(UInt32(yArr.count)))]
        let color = UIColor.yellow
        let size = CGSize(width: 40, height: 40)
        coin = SKSpriteNode(color: color, size: size)
        addChild(coin)
        coin.position.x = pointx
        coin.position.y = pointy
        
    }
    
    func makeStripe(width: CGFloat, height: CGFloat) -> SKSpriteNode {
        let color = UIColor(white: 1, alpha: 0.2)
        let size = CGSize(width: width, height: height)
        let stripe = SKSpriteNode(color: color, size: size)
        
        return stripe
    }
    
    func makeBoard(_ rows: Int, _ cols: Int) {
//        set to scene width and height
        let screenW = self.size.width
        let screenH = self.size.height
        for i in -1 ... 1 {
            let stripe = makeStripe(width: screenW, height: 60)
            addChild(stripe)
            stripe.position.x = screenW / 2
            stripe.position.y = (screenH / 2) + (65 * CGFloat(i))
        }
        
        for i in -1 ... 1 {
            let stripe = makeStripe(width: 60, height: screenH)
            addChild(stripe)
            stripe.position.x = (screenW / 2) + (65 * CGFloat(i))
            stripe.position.y = screenH / 2
        }
    }
}
