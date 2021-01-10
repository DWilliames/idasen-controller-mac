//
//  ViewController.swift
//  Desk Controller
//
//  Created by David Williames on 10/1/21.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBPeripheralDelegate, CBCentralManagerDelegate {

    // Properties
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    
    var peripherals = [CBPeripheral]()
    var desks = [DeskPeripheral]()
    
    var controller: DeskController? = nil
    
    @IBOutlet weak var heightLabel: NSTextField!
    
    @IBOutlet weak var upButton: NSButton!
    @IBOutlet weak var downButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let queue = DispatchQueue(label: "BT_queue")
        centralManager = CBCentralManager(delegate: self, queue: queue)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update: \(central.state)")
                    if central.state != .poweredOn {
                        print("Central is not powered on")
                    } else {
                        print("Central scanning for", DeskPeripheral.deskPositionServiceUUID);
                        central.scanForPeripherals(withServices: nil,
                                                   options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
                    }
    }
    
    // Handles the result of the scan
            func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
                
//                print("Discovered peripheral: \(peripheral)")
                
                guard !peripherals.contains(peripheral) else {
                    return
                }
                
                if let name = peripheral.name, name.contains("Desk") {
                    print("FOUND DESK: \(peripheral)")
                    
                    peripherals.append(peripheral)

                    central.connect(peripheral, options: nil)
                }


            }
    
    // The handler if we do connect succesfully
            func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
                print("Connected to peripheral: \(peripheral)")
                
                print(peripherals)
                
                guard peripherals.contains(peripheral) else {
                    return
                }
                
                print("Connected to Desk")
//                peripheral.discoverServices(nil)
                let desk = DeskPeripheral(peripheral: peripheral)
                desks.append(desk)
                
                controller = DeskController(desk: desk)
//                controller?.moveToPosition(.sit)
                controller?.onPositionChange = { position in
                    
                    DispatchQueue.main.async {
                        self.heightLabel.stringValue = "\(Int(position.rounded()))cm"
                    }
                    
                }

            }


}


extension Data {
    
    init?(hexString: String) {
      let len = hexString.count / 2
      var data = Data(capacity: len)
      var i = hexString.startIndex
      for _ in 0..<len {
        let j = hexString.index(i, offsetBy: 2)
        let bytes = hexString[i..<j]
        if var num = UInt8(bytes, radix: 16) {
          data.append(&num, count: 1)
        } else {
          return nil
        }
        i = j
      }
      self = data
    }
}
//
//extension Numeric {
//    init<D: DataProtocol>(_ data: D) {
//        var value: Self = .zero
//        let size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
//        assert(size == MemoryLayout.size(ofValue: value))
//        self = value
//    }
//}
//
//extension DataProtocol {
//    func value<N: Numeric>() -> N { .init(self) }
//}
//
//extension Data {
//    enum Endianess {
//        case little
//        case big
//    }
//
//    func toFloat(endianess: Endianess = .little) -> Float? {
//        guard self.count <= 4 else { return nil }
//
//        switch endianess {
//        case .big:
//            let data = [UInt8](repeating: 0x00, count: 4-self.count) + self
//            return data.withUnsafeBytes { $0.load(as: Float.self) }
//        case .little:
//            let data = self + [UInt8](repeating: 0x00, count: 4-self.count)
//            return data.reversed().withUnsafeBytes { $0.load(as: Float.self) }
//        }
//    }
//
//    var uint16: UInt16 {
//            get {
//                let i16array = self.withUnsafeBytes { $0.load(as: UInt16.self) }
//                return i16array
//            }
//        }
//}
