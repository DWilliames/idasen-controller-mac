//
//  ScriptableCommands.swift
//  Desk Controller
//
//  Created by David Williames on 12/1/21.
//

import Foundation

class MoveDeskCommand: NSScriptCommand {
    
    override func performDefaultImplementation() -> Any? {

        guard let parameter = directParameter as? String else {
            return nil
        }
        
        switch parameter {
        case "to-stand":
            DeskController.shared?.moveToPosition(.stand)
            break
        case "to-sit":
            DeskController.shared?.moveToPosition(.sit)
            break
        case "up":
            DeskController.shared?.moveUp()
            break
            
        case "down":
            DeskController.shared?.moveDown()
            break
        default:
            break
        }

        return nil
    }
}

