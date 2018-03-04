//
//  Rocket.swift
//  rocket
//
//  Created by Sky Xu on 3/1/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import SpriteKit

class Rocket: SKSpriteNode {
    
    

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
