//
//  ViewController.swift
//  Desk Controller
//
//  Created by David Williames on 10/1/21.
//

import Cocoa
import CoreBluetooth


class ViewController: NSViewController {
    
    
    
    var controller: DeskController? = nil
    
    let bluetoothManager = BluetoothManager.shared
    
    @IBOutlet weak var heightLabel: NSTextField?
    
    @IBOutlet weak var upButton: NSButton!
    @IBOutlet weak var downButton: NSButton!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        bluetoothManager.onConnectedPeripheralChange = { peripheral in
            print("Connect peripheral updated to: \(String(describing: peripheral))")
            guard let peripheral = peripheral else {
                print("No peripherals connected – it probably disconnected then")
                return
            }
            
            self.setControllerFor(deskPeripheral: peripheral)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let position = controller?.desk.position {
            onDeskPositionChange(position)
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setControllerFor(deskPeripheral: CBPeripheral) {
        print("Set controller for: \(deskPeripheral)")
        let desk = DeskPeripheral(peripheral: deskPeripheral)
        
        controller = DeskController(desk: desk)
        controller?.onPositionChange = { [weak self] deskPosition in
            DispatchQueue.main.async {
                self?.onDeskPositionChange(deskPosition)
            }
        }
    }
    
    func onDeskPositionChange(_ newPosition: Float) {
        DispatchQueue.main.async {
            self.heightLabel?.stringValue = "\(Int(newPosition.rounded()))cm"
        }
    }
    
    func reconnect() {
        print("Reconnect if necessary")
        
        if bluetoothManager.connectedPeripheral == nil {
            bluetoothManager.startScanning()
        }
    }
    
    @IBAction func moveUpClicked(_ sender: TouchButton) {
        guard let controller = controller else {
            return
        }
        
        if !sender.isPressed {
            controller.stopMoving()
        } else if let position = controller.desk.position, controller.preferences.stand > position {
            controller.moveToPosition(.stand)
        } else {
            controller.moveUp()
        }
    }
    
    @IBAction func moveDownClicked(_ sender: TouchButton) {
        guard let controller = controller else {
            return
        }
        
        if !sender.isPressed {
            controller.stopMoving()
        } else if let position = controller.desk.position, controller.preferences.sit < position {
            controller.moveToPosition(.sit)
        } else {
            controller.moveDown()
        }
    }
    
    @IBAction func sit(_ sender: Any) {
        controller?.moveToPosition(.sit)
    }
    
    @IBAction func stand(_ sender: Any) {
        controller?.moveToPosition(.stand)
    }
    
    @IBAction func stop(_ sender: Any) {
        controller?.stopMoving()
    }

}


