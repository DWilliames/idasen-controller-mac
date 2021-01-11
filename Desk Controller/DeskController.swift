//
//  DeskController.swift
//  Desk Controller
//
//  Created by David Williames on 10/1/21.
//

import Cocoa

enum Position {
    case sit, stand
}

enum MovingDirection {
    case up, down, none
}

struct PositionPreferences {
    let sit: Float // Position in cm
    let stand: Float // Position in cm
    
    func preference(for position: Position) -> Float {
        switch position {
        case .sit:
            return sit
        case .stand:
            return stand
        }
    }
}

class DeskController: NSObject {
    
    var currentMovingDirection: MovingDirection = .none
    
    var movingToPosition: Position? = nil {
        didSet {
            moveIfNeeded()
        }
    }

    let desk: DeskPeripheral
    // My preferences
    let preferences = PositionPreferences(sit: 72, stand: 119)
//    let preferences = PositionPreferences(sit: 72, stand: 80)
    
    let distanceOffset: Float = 0.5 // e.g if we're within this of the distance and it's currently moving then we can probably stop
    let minDurationIncrements: TimeInterval = 0.5
    var lastMoveTime: Date
    
    let minMovementIncrements: Float = 0.5 // Make sure it's moved at least 0.75cm before moving again
    var previousMovementIncrement: Float
    
    var onPositionChange: (Float) -> Void = { _ in }
    
    init(desk: DeskPeripheral) {
        self.desk = desk
        self.lastMoveTime = Date().addingTimeInterval(-minDurationIncrements)
        self.previousMovementIncrement = minMovementIncrements
        super.init()
        
        desk.onPositionChange = { position in
            print("Position changed...")
            print("Position: \(position)cm")
            self.moveIfNeeded()
            self.onPositionChange(position)
        }
    }
    
    
    func moveUp() {
        print("Move up")
        guard let characteristic = desk.controlCharacteristic else {
            return
        }
        
        if let data = Data(hexString: "4700") {
            desk.peripheral.writeValue(data, for: characteristic, type: .withResponse)
            lastMoveTime = Date()
            currentMovingDirection = .up
            print("WRITE MOVE UP")
        }
    }
    
    func moveDown() {
        print("Move Down")
        guard let characteristic = desk.controlCharacteristic else {
            return
        }
        
        if let data = Data(hexString: "4600") {
            desk.peripheral.writeValue(data, for: characteristic, type: .withResponse)
            lastMoveTime = Date()
            currentMovingDirection = .down
            print("WRITE MOVE DOWN")
        }
    }
    
    func stopMoving() {
        guard let characteristic = desk.controlCharacteristic else {
            return
        }
        
        if let data = Data(hexString: "FF00") {
            desk.peripheral.writeValue(data, for: characteristic, type: .withResponse)
            
        }
        
        currentMovingDirection = .none
        movingToPosition = nil
        previousPosition = nil
    }
    
    func moveToPosition(_ position: Position) {
        movingToPosition = position
        
        print("Move to position: \(position)")
    }
    
    
    
    var previousPosition: Float?
    
    private func moveIfNeeded() {

        guard let toPosition = movingToPosition, var position = desk.position else {
            return
        }
        
        let speed = desk.speed
        
        let timeSinceLastMove = lastMoveTime.distance(to: Date())
        let distanceSincePreviousPosition = abs((previousPosition ?? position + minMovementIncrements) - position)
        
        print("Since last move: \(distanceSincePreviousPosition)cm")
        
        print("Position: \(position)cm")
        print("Speed: \(speed)")
        print("Preferences: \(preferences)")
        
        let positionToMoveTo = preferences.preference(for: toPosition)

        
        if positionToMoveTo > position {
            
            if currentMovingDirection == .up {
                position += distanceOffset
            }
            
            if position < positionToMoveTo && speed >= 0 {
                if timeSinceLastMove > minDurationIncrements && distanceSincePreviousPosition >= minMovementIncrements {
                    previousPosition = position
                    moveUp()
                }
                
            } else {
                stopMoving()
            }
        } else if positionToMoveTo < position {
            
            if currentMovingDirection == .down {
                position -= distanceOffset
            }
            
            if position > positionToMoveTo && speed <= 0 {
                if timeSinceLastMove > minDurationIncrements && distanceSincePreviousPosition >= minMovementIncrements {
                    previousPosition = position
                    moveDown()
                }
            } else {
                stopMoving()
            }
        }
        
        
    }
}
