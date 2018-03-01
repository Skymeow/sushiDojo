//
//  GameScene.swift
//  sushi dojo
//
//  Created by Sky Xu on 2/24/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit

//  for tracking side
enum Side {
    case left, right, none
}

class GameScene: SKScene {
    
//    var sushiBasePiece: SushiPiece?
    var sushiTower = [SushiPiece]()
    lazy var sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
    lazy var character = childNode(withName: "chacharacter") as! Character
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
      
        /* Setup chopstick connections */
        sushiBasePiece.connectChopsticks()
       
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: self)
//        decide if the touch is on left or right side of screen
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
    }
    
    func addTowerPiece(side: Side) {
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        let lastPiece = sushiTower.last ?? sushiBasePiece
//        default position is the first item at sushitower
//        newPiece.position = lastPiece.position ?? sushiBasePiece.position
        newPiece.position.x = lastPiece.position.x
        newPiece.position.y = lastPiece.position.y + 55
        
        let lastZPosition = lastPiece.zPosition ?? sushiBasePiece.zPosition
//        increment z position of last piece, to make sure it lands on top of last piece
        lastPiece.zPosition = lastZPosition + 1
        
        newPiece.side = side
        addChild(newPiece)
        sushiTower.append(newPiece)
    }
    
    func addRandomPieces(total: Int) {
        for _ in 1 ... total {
            let lastPiece = sushiTower.last!
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                let rand = arc4random_uniform(100)
//                45% chance for left/right, 10% for none side
                if rand < 45 {
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    addTowerPiece(side: .right)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
}
