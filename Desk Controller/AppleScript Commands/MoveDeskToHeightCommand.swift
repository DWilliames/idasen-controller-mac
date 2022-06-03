//
//  MoveDeskToHeightCommand.swift
//  Desk Controller
//
//  Created by David Williames on 3/6/2022.
//

import Foundation


class MoveDeskToHeightCommand: NSScriptCommand {
    
    override func performDefaultImplementation() -> Any? {
        
        guard let parameter = directParameter as? String else {
            return nil
        }
        
        var height: Float?
        
        print("Move desk to: \(parameter)")
        
        if parameter.hasSuffix("cm") {
            height = Float(parameter.dropLast(2))
        } else if parameter.hasSuffix("in") {
            height = Float(parameter.dropLast(2))?.convertToCentimeters()
        } else if let value = Float(parameter) {
            height = Preferences.shared.isMetric ? value : value.convertToCentimeters()
        }
        
        if let height = height {
            DeskController.shared?.moveToHeight(height)
        }
        
        return nil
    }
}
