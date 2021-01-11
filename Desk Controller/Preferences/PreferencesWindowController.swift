//
//  PreferencesWindowController.swift
//  Desk Controller
//
//  Created by David Williames on 11/1/21.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    @IBOutlet weak var standingHeightField: NSTextField!
    @IBOutlet weak var sittingHeightField: NSTextField!
    
    @IBOutlet weak var unitsPopUpButton: NSPopUpButton!
    @IBOutlet weak var currentHeightField: NSTextField?
    
    @IBOutlet weak var openAtLoginCheckbox: NSButton!
    
    static let sharedInstance = PreferencesWindowController(windowNibName: "PreferencesWindowController")
    
    var deskController: DeskController? {
        didSet {
            deskPosition = deskController?.desk.position
        }
    }
    
    var deskPosition: Float? {
        didSet {
            currentHeightField?.isEnabled = (deskPosition != nil)
            
            var offsetPosition = Preferences.shared.positionOffset + (deskPosition ?? 0)
            if !Preferences.shared.isMetric {
                offsetPosition = offsetPosition.convertToInches()
            }
            currentHeightField?.stringValue = String(format: "%.1f", offsetPosition)
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        openAtLoginCheckbox.state = Preferences.shared.openAtLogin ? .on : .off
        
        unitsPopUpButton.selectItem(at: Preferences.shared.isMetric ? 0 : 1)
        
        updateLabels()
        
        deskController?.onPositionChange({ [weak self] position in
            self?.deskPosition = position
        })
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        AppDelegate.bringToFront(window: self.window!)
    }
    
    func updateLabels() {
        
        var standingPosition = Preferences.shared.standingPosition
        var sittingPosition = Preferences.shared.sittingPosition
        
        if !Preferences.shared.isMetric {
            print("\(standingPosition)cm = \(standingPosition.convertToInches())in")
            standingPosition = standingPosition.convertToInches()
            sittingPosition = sittingPosition.convertToInches()
        }
        
        standingHeightField.stringValue = String(format: "%.1f", standingPosition)
        sittingHeightField.stringValue = String(format: "%.1f", sittingPosition)
        
        var offsetPosition = Preferences.shared.positionOffset + (deskPosition ?? 0)
        if !Preferences.shared.isMetric {
            offsetPosition = offsetPosition.convertToInches()
        }
        
        currentHeightField?.stringValue = String(format: "%.1f", offsetPosition)
    }
    
    @IBAction func changeStandingHeightField(_ sender: NSTextField) {
        
        if var newPosition = Float(standingHeightField.stringValue) {
            if !Preferences.shared.isMetric {
                newPosition = newPosition.convertToCentimeters()
            }
            Preferences.shared.standingPosition = newPosition
        }
        
    }
    
    @IBAction func changedSittingHeightField(_ sender: NSTextField) {
        
        if var newPosition = Float(sittingHeightField.stringValue) {
            if !Preferences.shared.isMetric {
                newPosition = newPosition.convertToCentimeters()
            }
            Preferences.shared.sittingPosition = newPosition
        }
    }
    
    @IBAction func changedCurrentHeightField(_ sender: NSTextField) {
        
        if var newPosition = Float(sender.stringValue), let deskPosition = deskPosition {
            if !Preferences.shared.isMetric {
                newPosition = newPosition.convertToCentimeters()
            }
            let offset = newPosition - deskPosition
            Preferences.shared.positionOffset = offset
        }
    }
    
    @IBAction func changedUnitsPopUpButton(_ sender: NSPopUpButton) {
        Preferences.shared.isMetric = sender.titleOfSelectedItem == "cm"
        updateLabels()
    }
    
    @IBAction func toggledOpenAtLoginCheckbox(_ sender: NSButton) {
        Preferences.shared.openAtLogin = sender.state == .on
    }
    
    
}
