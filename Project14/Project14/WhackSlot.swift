//
//  WhackSlot.swift
//  Project14
//
//  Created by Álvaro Ávalos Hernández on 06/08/20.
//  Copyright © 2020 Álvaro Ávalos Hernández. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        //Usa una imagen como mascara de recorte
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1
        charNode.yScale = 1
        //Añade movimiento al nodo
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        //Cambia la textura del nodo
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        //Crea una acción que espera un período de tiempo, medido en segundos
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        //Ejecutará cualquier código que queramos, siempre como closure
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        //Toma una serie de acciones y las ejecuta en orden. Cada acción no comenzará
        //a ejecutarse hasta que finalice la anterior.
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
}
