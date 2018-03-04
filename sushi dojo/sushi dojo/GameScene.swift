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
// for game state
enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    
//    var sushiBasePiece: SushiPiece?
    var sushiTower = [SushiPiece]()
    lazy var sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
    lazy var character = childNode(withName: "character") as! Character
    
    var state: GameState = .title
    
    lazy var playButton = childNode(withName: "playButton") as! MSButtonNode
   
    override func didMove(to view: SKView) {
        super.didMove(to: view)
      
        /* Setup chopstick connections */
        sushiBasePiece.connectChopsticks()
       
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
        
//        start the game when press the button
        playButton.selectedHandler = {
            self.state = .ready
        }
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
        
        // MARK:  remove the item on top of the base item and add a random one
        if let firstPiece = sushiTower.first {
//            check character side against sushi piece side
            if character.side == firstPiece.side {
                gameOver()
                return
            }
            sushiTower.removeFirst()
//            remove child node
            firstPiece.flip(character.side)
            addRandomPieces(total: 1)
        }
        
//        stop if game not ready to play
        if state == .gameOver || state == .title {return}
//        first touch game
        if state == .ready {
            state = .playing
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
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
    
    //    MARK: don't work
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    func gameOver() {
        state = .gameOver
//        turn all the sushi to be red
        for sushiPiece in sushiTower {
            sushiPiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5))
        }
//        turn base to red
        sushiBasePiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5))
//        make player turn red
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5))
//        change play button selection handler
        playButton.selectedHandler = {
//            grab reference to spriteKit view
            let skView = self.view as SKView!
//            load game scene
            guard let scene = GameScene(fileNamed: "GameScene") as! GameScene! else { return }
            scene.scaleMode = .aspectFill
            
//            restart
            skView?.presentScene(scene)
        }
    }
    
}
