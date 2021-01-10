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
                    
                    
//                    peripheral.delegate = self
                    central.connect(peripheral, options: nil)
                    
//                    central.stopScan()
                }
//                print(peripheral.services)

//                // We've found it so stop scan
//                self.centralManager?.stopScan()
//
//                // Copy the peripheral instance
//                self.peripheral = peripheral
//                self.peripheral?.delegate = self
//
//                // Connect!
//                self.centralManager?.connect(peripheral, options: nil)

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
                controller?.moveToPosition(.sit)
                
                
                
//                if peripheral == self.peripheral {
//                    print("Connected to your Desk")
//                    peripheral.discoverServices([DeskPeripheral.deskPositionServiceUUID])
//                }
            }
//
//    // Handles discovery event
//            func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//
//                guard deskPeripherals.contains(peripheral), let services = peripheral.services else {
//                    return
//                }
//
//                services.forEach { service in
//                    print("Discovered service: \(service)")
//                    peripheral.discoverCharacteristics(nil, for: service)
//                }
//
////                print("Discovered peripheral services: \(peripheral.services)")
//
////                if let services = peripheral.services {
////                    for service in services {
////                        if service.uuid == DeskPeripheral.deskPositionServiceUUID {
////                            print("Desk service found")
////                            //Now kick off discovery of characteristics
////                            peripheral.discoverCharacteristics([DeskPeripheral.deskPositionCharacteristicUUID], for: service)
////                            return
////                        }
////                    }
////                }
//            }
//
//    // Handling discovery of characteristics
//            func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//
//                guard deskPeripherals.contains(peripheral), let characteristics = service.characteristics else {
//                    return
//                }
//
//                characteristics.forEach { characteristic in
//                    print("Discovered characteristic: \(characteristic)")
//
//
////                    up: Buffer.from("4700", "hex"),
//
//                    if characteristic.uuid == DeskPeripheral.deskControlCharacteristicUUID {
//                        if let data = Data(hexString: "4700") {
//                            peripheral.writeValue(data, for: characteristic, type: .withResponse)
//
//                        }
//
//                    }
//
//                }
//
////                print("Discovered peripheral characteristics: \(service.characteristics), for service: \(service)")
////
////                if let characteristics = service.characteristics {
////                    for characteristic in characteristics {
////                        if characteristic.uuid == DeskPeripheral.deskPositionCharacteristicUUID {
////                            print("Desk position characteristic found")
////                        }
////                    }
////                }
//            }

    var count = 0
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Wrote value for: \(characteristic)")
        peripheral.readValue(for: characteristic)
        count += 1
        
//        if count < 50 {
//            if let data = Data(hexString: "4700") {
//                peripheral.writeValue(data, for: characteristic, type: .withResponse)
//
//            }
//        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Read value: \(characteristic.value) for: \(characteristic)")
    }

}


//extension CBPeripheral: Equatable {
//
//    static func == (lhs: CBPeripheral, rhs: CBPeripheral) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//}


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
