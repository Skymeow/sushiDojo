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
    
//    like viewdidappear (life cycle method)
    override func didMove(to view: SKView) {
        makeBoard(3,3)
        makePlayer()
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
