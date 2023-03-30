//
//  MechanicsController.swift
//  Fly
//
//  Created by Leonardo Daniele on 30/03/23.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

class MechanicsController {
    static func getInclination(motionManager: CMMotionManager) -> Double {
        var inclination: Double = 0
        
        if motionManager.accelerometerData != nil {
            inclination = motionManager.accelerometerData!.acceleration.y
        }
        
        return inclination
    }
    
    static func getTiltedGravityVector(motionManager: CMMotionManager) -> CGVector {
        let tilt = checkTilt(actualTilt: getInclination(motionManager: motionManager))
        let gravityForce = CGFloat(-9.8)*0.10
        let sin = CGFloat(tilt)
        let cos = cos(asin(sin))
        
        let tiltedGravityVector = CGVector(dx: gravityForce*sin, dy: gravityForce*cos)
        
        return tiltedGravityVector
    }
    
    static func checkTilt(actualTilt: Double) -> Double {
        let maxTilt = 0.9
        let minTilt = -maxTilt
        var tilt = actualTilt
        
        if actualTilt >= maxTilt {
            tilt = maxTilt
        } else if actualTilt <= minTilt {
            tilt = minTilt
        }
        
        return tilt
    }
    
    static func setupNode(node: SKNode, nodeSelfCategory: UInt32, nodeCollisionCategory: UInt32) {
        node.physicsBody?.categoryBitMask = nodeSelfCategory
        node.physicsBody?.collisionBitMask = nodeCollisionCategory
        node.physicsBody?.contactTestBitMask = nodeCollisionCategory
    }

}

