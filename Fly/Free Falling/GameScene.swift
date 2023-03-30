//
//  GameScene.swift
//  Fly
//
//  Created by Leonardo Daniele on 28/03/23.
//

import SpriteKit
import GameplayKit
import CoreMotion

struct PhysicsCategory {
    static let none   : UInt32 = 0
    static let player : UInt32 = 0b0001
    static let wall : UInt32 = 0b0011
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MOTION MANAGER
    let motionManager = CMMotionManager()
    
    //NODES
    var playerNode: SKNode!
    var bgNode: SKNode!
    
    var spawnPoint = CGPoint()
    
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
        
        bgNode = childNode(withName: "bg")
        
        playerNode = childNode(withName: "player")
        spawnPoint = playerNode.position
        MechanicsController.setupNode(node: playerNode, nodeSelfCategory: PhysicsCategory.player, nodeCollisionCategory: PhysicsCategory.wall)
        
        self.camera = childNode(withName: "camera") as? SKCameraNode
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // FIX GRAVITY
        physicsWorld.gravity = MechanicsController.getTiltedGravityVector(motionManager: motionManager)
        let cameraPosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y - 300)
        camera?.position = cameraPosition
        
        if(playerNode.position.y <= -bgNode.frame.height) {
            camera?.position = spawnPoint
            playerNode.position.y = 0
            camera?.position = cameraPosition
        }
        if(playerNode.position.x <= -bgNode.frame.width || playerNode.position.x >= bgNode.frame.width) {
            playerNode.position.x = 0
            camera?.position = cameraPosition
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(playerNode.position)
    }
}
