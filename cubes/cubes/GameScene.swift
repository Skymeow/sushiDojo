//
//  GameScene.swift
//  cubes
//
//  Created by Sky Xu on 2/22/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var start: CGPoint?
//    like viewdidappear (life cycle method)
    override func didMove(to view: SKView) {
        
        makeBoard(3, 3)
//        make random boxes in coloums
        generateStart { (success, starts) in
            self.start = self.startPoints[Int(arc4random_uniform(UInt32(self.startPoints.count)))]
            self.makeBox(self.start!.x, self.start!.y)
            
        }
        
        makePlayer()
    }
    
    func makeBoxEveryOneSec() {
        
    }
    
// make boxes that moves across screen
    func makeBox(_ startX: CGFloat,_ startY: CGFloat) {
        let color = UIColor.black
        let size = CGSize(width: 40, height: 40)
        let box = SKSpriteNode(color: color, size: size)
        addChild(box)
        
        box.position.x = startX
        box.position.y = startY
        self.moveBoxVertical(a: box)
    }
    
//    function that moves the box
    func moveBoxHorizontal() {
        let vector = CGVector(dx: 40, dy: 0)
        SKAction.move(by: vector, duration: 3)
    }
    
//    create another function to remove the move action in a sequence
    func moveBoxVertical(a: SKSpriteNode) {
        let point = CGPoint(x: a.position.x, y: self.size.height + 20)
        let move = SKAction.move(to: point, duration: 3)
        a.run(move)
    }
    
//    make start and end point (array)
    var startPoints = [CGPoint]()
    func generateStart(completion: @escaping (Bool, [CGPoint]) -> Void) {
        let screenW = self.size.width
        let screenH = self.size.height

        for i in -1 ... 1 {
            let x = CGFloat(screenW / 2)
            let y = CGFloat((screenH / 2) + (65 * CGFloat(i)))
            let y2 = CGFloat(screenH / 2)
            let x2 = CGFloat((screenW / 2) + (65 * CGFloat(i)))
            
            let point1 = CGPoint(x: x, y: y)
            let point2 = CGPoint(x: x2, y: y2)
            startPoints.append(point1)
//            startPoints.append(point2)
        }
        completion(true, startPoints)
    }
    

    
    
    func makePlayer() {
        let color = UIColor.red
        let size = CGSize(width: 40, height: 40)
        let box = SKSpriteNode(color: color, size: size)
        addChild(box)
        
        box.position.x = 200
        box.position.y = 200
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
