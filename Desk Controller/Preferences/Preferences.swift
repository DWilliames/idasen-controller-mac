//
//  PositionPreferences.swift
//  Desk Controller
//
//  Created by David Williames on 11/1/21.
//

import Foundation
import LaunchAtLogin

enum Position {
    case sit, stand, favorite1, favorite2, favorite3, custom(height: Float)
}

class Preferences {
    
    static let shared = Preferences()
    
    private let standingKey = "standingPositionValue"
    private let sittingKey = "sittingPositionValue"

    private let favorite1Key = "favorite1PositionValue"
    private let favorite2Key = "favorite2PositionValue"
    private let favorite3Key = "favorite3PositionValue"

    private let automaticStandKey = "automaticStandValue"
    private let automaticStandInactivityKey = "automaticStandInactivityKey"
    private let automaticStandEnabledKey = "automaticStandEnabledKey"
    
    private let offsetKey = "positionOffsetValue"
    
    private let isMetricKey = "isMetric"
    
    private let hasLaunched = "hasLaunched"

    var standingPosition: Float {
        get {
            if let position = UserDefaults.standard.value(forKey: standingKey) {
                return position as! Float
            }
            return 110 // Default standing position is
        }
        
        set {
            // print("Save new Standing position: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: standingKey)
        }
    }
    
    var sittingPosition: Float {
        get {
            if let position = UserDefaults.standard.value(forKey: sittingKey) {
                return position as! Float
            }
            return 70 // Default sitting position
        }
        
        set {
            // print("Save new Sitting position: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: sittingKey)
        }
    }
    
    var favorite1Position: Float {
        get {
            if let position = UserDefaults.standard.value(forKey: favorite1Key) {
                return position as! Float
            }
            return 80 // Default favorite 1 position
        }

        set {
            // print("Save new Sitting position: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: favorite1Key)
        }
    }

    var favorite2Position: Float {
        get {
            if let position = UserDefaults.standard.value(forKey: favorite2Key) {
                return position as! Float
            }
            return 90 // Default favorite 2 position
        }

        set {
            // print("Save new Sitting position: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: favorite2Key)
        }
    }

    var favorite3Position: Float {
        get {
            if let position = UserDefaults.standard.value(forKey: favorite3Key) {
                return position as! Float
            }
            return 100 // Default favorite 3 position
        }

        set {
            // print("Save new Sitting position: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: favorite3Key)
        }
    }

    var automaticStandPerHour: TimeInterval {
        get {
            if let standTime = UserDefaults.standard.value(forKey: automaticStandKey) {
                return standTime as! TimeInterval
            }
            return 10 * 60 // Default automatic stand
        }
        
        set {
            //print("Save new Automatic stand per hour: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: automaticStandKey)
            DeskController.shared?.autoStand.update()
        }
    }
    
    var automaticStandInactivity: TimeInterval {
        get {
            if let inactiveTime = UserDefaults.standard.value(forKey: automaticStandInactivityKey) {
                return inactiveTime as! TimeInterval
            }
            return 5 * 60 // Default min
        }
        
        set {
            //print("Save new Automatic stand inactivity: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: automaticStandInactivityKey)
        }
    }
    
    var automaticStandEnabled: Bool {
        get {
            if let autoStandEnabled = UserDefaults.standard.value(forKey: automaticStandEnabledKey) {
                return autoStandEnabled as! Bool
            }
            return false // Default disabled
        }
        
        set {
            //print("Saving automatic stand enabled \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: automaticStandEnabledKey)
            // Stop timers
            DeskController.shared?.autoStand.update()
        }
    }
    
    var positionOffset: Float {
        get {
            if let offset = UserDefaults.standard.value(forKey: offsetKey) {
                return offset as! Float
            }
            return 0 // Default offset
        }
        
        set {
            // print("Save new position Offset: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: offsetKey)
        }
    }
    
    var isMetric: Bool {
        get {
            if let metric = UserDefaults.standard.value(forKey: isMetricKey) {
                return metric as! Bool
            }
            return NSLocale.current.usesMetricSystem // Default from locale
        }
        
        set {
            // print("Saving is metric? \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: isMetricKey)
        }
    }
    
    var openAtLogin: Bool {
        get {
            return LaunchAtLogin.isEnabled
        }
        set {
            // print("Saving launch at login: \(newValue)")
            LaunchAtLogin.isEnabled = newValue
        }
    }
    
    var isFirstLaunch: Bool {
        get {
            if let hasLaunchedBefore = UserDefaults.standard.value(forKey: hasLaunched) {
                return !(hasLaunchedBefore as! Bool)
            }
            return true
        }
        
        set {
            UserDefaults.standard.setValue(!newValue, forKey: hasLaunched)
        }
    }

    func forPosition(_ position: Position) -> Float {
        switch position {
        case .sit:
            return sittingPosition
        case .stand:
            return standingPosition
        case .favorite1:
            return favorite1Position
        case .favorite2:
            return favorite2Position
        case .favorite3:
            return favorite3Position
        case .custom(let height):
            return height
        }
    }
    
    var measurementMetric: Unit {
        return isMetric ? UnitLength.centimeters : UnitLength.inches
    }
}
