//
//  PositionPreferences.swift
//  Desk Controller
//
//  Created by David Williames on 11/1/21.
//

import Foundation
import LaunchAtLogin

enum Position {
    case sit, stand
}

class Preferences {
    
    static let shared = Preferences()
    
    private let standingKey = "standingPositionValue"
    private let sittingKey = "sittingPositionValue"
    
    private let offsetKey = "positionOffsetValue"
    
    private let isMetricKey = "isMetric"
    
    private let hasLaunched = "hasLaunched"
    
    // 72, 119

    var standingPosition: Float {
        get {
            if let position = UserDefaults.standard.value(forKey: standingKey) {
                return position as! Float
            }
            return 119//110 // Default standing position is
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
            return 73//70 // Default sitting position
        }
        
        set {
            // print("Save new Sitting position: \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: sittingKey)
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
        }
    }
    
    var measurementMetric: Unit {
        return isMetric ? UnitLength.centimeters : UnitLength.inches
    }
}
