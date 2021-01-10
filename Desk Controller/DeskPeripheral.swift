//
//  DeskPeripheral.swift
//  Desk Controller
//
//  Created by David Williames on 10/1/21.
//

import Cocoa
import CoreBluetooth

class DeskPeripheral: NSObject {
    
    
//      GENERIC_ACCESS      = "00001800-0000-1000-8000-00805F9B34FB"
//      REFERENCE_INPUT     = "99FA0030-338A-1024-8A49-009C0215F78A"
//      REFERENCE_OUTPUT    = "99FA0020-338A-1024-8A49-009C0215F78A"
//      DPG                 = "99FA0010-338A-1024-8A49-009C0215F78A"
//      CONTROL             = "99FA0001-338A-1024-8A49-009C0215F78A"
    
//    ## contains two accessors: 'name' and 'value'
//
//        ## generic access
//        DEVICE_NAME     = ("00002A00-0000-1000-8000-00805F9B34FB", 0x03)
//        SERVICE_CHANGED = ("00002A05-0000-1000-8000-00805F9B34FB", 0x0A)
//        MANUFACTURER    = ("00002A29-0000-1000-8000-00805F9B34FB", 0x18)
//        MODEL_NUMBER    = ("00002A24-0000-1000-8000-00805F9B34FB", 0x1A)
//
//        ## reference input
//        CTRL1 = ("99FA0031-338A-1024-8A49-009C0215F78A", 0x3A)      # move to
//    #     CTRL2 = ("99FA0032-338A-1024-8A49-009C0215F78A"
//    #     CTRL3 = ("99FA0033-338A-1024-8A49-009C0215F78A"
//    #     CTRL4 = ("99FA0034-338A-1024-8A49-009C0215F78A"
//
//        ## reference output
//        HEIGHT_SPEED = ("99FA0021-338A-1024-8A49-009C0215F78A", 0x1D)            ## ONE
//        TWO          = ("99FA0022-338A-1024-8A49-009C0215F78A", 0x20)
//        THREE        = ("99FA0023-338A-1024-8A49-009C0215F78A", 0x23)
//        FOUR         = ("99FA0024-338A-1024-8A49-009C0215F78A", 0x26)
//        FIVE         = ("99FA0025-338A-1024-8A49-009C0215F78A", 0x29)
//        SIX          = ("99FA0026-338A-1024-8A49-009C0215F78A", 0x2C)
//        SEVEN        = ("99FA0027-338A-1024-8A49-009C0215F78A", 0x2F)
//        EIGHT        = ("99FA0028-338A-1024-8A49-009C0215F78A", 0x32)
//        MASK         = ("99FA0029-338A-1024-8A49-009C0215F78A", 0x35)
//    #             DETECT_MASK(UUID.fromString("99FA002A-338A-1024-8A49-009C0215F78A"));
//
//        DPG         = ("99FA0011-338A-1024-8A49-009C0215F78A", 0x14)
//
//        CONTROL     = ("99FA0002-338A-1024-8A49-009C0215F78A", 0x0E)
//        ERROR       = ("99FA0003-338A-1024-8A49-009C0215F78A", 0x10)
    
    
    
    
    
    
//    DPG_COMMAND_HANDLE = 0x0014
//    REFERENCE_OUTPUT_HANDLE = 0x001d
//
//
//    DPG_COMMAND_NOTIFY_HANDLE = 0x0015  # Used for DPG Commands anwsers
//
//    NAME_HANDLE = 0x0003
//
//    PROP_GET_CAPABILITIES = 0x80
//    PROP_DESK_OFFSET = 0x81
//    PROP_USER_ID = 0x86
//    PROP_MEMORY_POSITION_1 = 0x89
//    PROP_MEMORY_POSITION_2 = 0x8a
//
//
//    DEFAULT_TIMEOUT = 3
//    DPG_COMMAND_HANDLE = 0x0014
//
//
//    MOVE_TO_HANDLE = 0x003a
//    REFERENCE_OUTPUT_NOTIFY_HANDLE = 0x001e         # Used for desk offset / speed notifications
    
    
    
    
//    PRODUCT_INFO = 8
//    GET_SETUP = 10            ## does not work
//#     CURRENT_TIME(22),
//    GET_CAPABILITIES = 128
//    DESK_OFFSET = 129           ## 0x81
//#     GET_OEM_ID = 130,
//#     GET_OEM_NAME(131),
//#     GET_SET_COMPANY_ID(132),
//#     GET_SET_COMPANY_NAME(133),
//    USER_ID = 134               ## 0x86
//    GET_SET_REMINDER_TIME = 135
//    REMINDER_SETTING = 136
//    GET_SET_MEMORY_POSITION_1 = 137
//    GET_SET_MEMORY_POSITION_2 = 138
//    GET_SET_MEMORY_POSITION_3 = 139
//    GET_SET_MEMORY_POSITION_4 = 140
//#     READ_WRITE_REFERENCE_SPEED_1(216),
//#     READ_WRITE_REFERENCE_SPEED_2(217),
//#     READ_WRITE_REFERENCE_SPEED_3(218),
//#     READ_WRITE_REFERENCE_SPEED_4(219),
//#     READ_WRITE_REFERENCE_SPEED_5(220),
//#     READ_WRITE_REFERENCE_SPEED_6(221),
//#     READ_WRITE_REFERENCE_SPEED_7(222),
//#     READ_WRITE_REFERENCE_SPEED_8(223),
//#     GET_MASSAGE_PARAMETERS(244),
//#     GET_SET_MASSAGE_VALUES(245),
//    GET_LOG_ENTRY = 144
//
    
    
    
    
    public static let deskPositionServiceUUID = CBUUID.init(string: "99FA0020-338A-1024-8A49-009C0215F78A")
    public static let deskPositionCharacteristicUUID = CBUUID.init(string: "99FA0021-338A-1024-8A49-009C0215F78A")
    
    public static let deskControlServiceUUID = CBUUID.init(string: "99FA0001-338A-1024-8A49-009C0215F78A")
    public static let deskControlCharacteristicUUID = CBUUID.init(string: "99FA0002-338A-1024-8A49-009C0215F78A")
    
    static let heightPositionOffset: Float = 61.5
    
    
    let peripheral: CBPeripheral
    
    var positionService: CBService?
    var positionCharacteristic: CBCharacteristic?
        
    var controlService: CBService?
    var controlCharacteristic: CBCharacteristic?
    
    
    var speed: Float = 0
    
    var onPositionChange: (Float) -> Void = { _ in }
    var position: Float = DeskPeripheral.heightPositionOffset {
        didSet {
            print("\(position)cm")
            onPositionChange(position)
        }
    }
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        
        super.init()
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func getPosition() {
        guard let positionCharacteristic = positionCharacteristic else {
            return
        }
        
        peripheral.readValue(for: positionCharacteristic)
    }
    
//    var position: CGFloat? {
//        guard let positionCharacteristic = positionCharacteristic else {
//            return
//        }
//
//        return positionCharacteristic.properties
//    }

}

extension DeskPeripheral: CBPeripheralDelegate {
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard peripheral == self.peripheral, let services = peripheral.services else {
            return
        }
        
        services.forEach { service in
            if service.uuid == DeskPeripheral.deskPositionServiceUUID {
                positionService = service
                print("Discovered position service: \(service)")
            } else if service.uuid == DeskPeripheral.deskControlServiceUUID {
                controlService = service
                print("Discovered control service: \(service)")
            } else {
                return
            }
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard peripheral == self.peripheral, let characteristics = service.characteristics else {
            return
        }
        
        characteristics.forEach { characteristic in
            if characteristic.uuid == DeskPeripheral.deskPositionCharacteristicUUID {
                print("Discovered position characteristic: \(characteristic)")
                positionCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
//                getPosition()
            } else if characteristic.uuid == DeskPeripheral.deskControlCharacteristicUUID {
                print("Discovered control characteristic: \(characteristic)")
                controlCharacteristic = characteristic
            } else {
                return
            }
            
            print(characteristic.properties)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic == positionCharacteristic, let value = characteristic.value {
            
            // Position = 16 Little Endian – Unsigned =
            // SPeed = 16 Little Endian – Signed
            
            
            
            let positionValue = [value[0], value[1]].withUnsafeBytes {
                $0.load(as: UInt16.self)
            }
            
            let speedValue = [value[2], value[3]].withUnsafeBytes {
                $0.load(as: Int16.self)
            }
            
            print(speedValue)
            
            speed = Float(speedValue)
            position = Float(positionValue) / 100 + DeskPeripheral.heightPositionOffset

        }
//
//        print("Read value: \(characteristic.value) for: \(characteristic)")
//        print(characteristic.properties)
//
//        if let value = characteristic.value {
//            print(String(decoding: value, as: UTF8.self))
//            print(String(bytes: value, encoding: String.Encoding.utf8))
////            let position = Float(String(decoding: value, as: UTF8.self)) ?? 0
////            print("\(position / 100)cm")
////
////            for i in 0..<value.count {
////                print(value[i])
////            }
//
//            print(value.hexEncodedString())
//
//            let int_value = UInt64(value.hexEncodedString(), radix: 16)
//            print(int_value)
//
//            print(value.toFloat())
//            print("\(Float(value.uint16) / 100 + 62)cm")
////            print(convertInputValue(value))
//        }
//
//        var wavelength: UInt16?
//        if let data = characteristic.value {
//            var bytes = Array(repeating: 0 as UInt8, count:data.count/MemoryLayout<UInt8>.size)
//
//            data.copyBytes(to: &bytes, count:data.count)
//            let data16 = bytes.map { UInt16($0) }
//            wavelength = 256 * data16[1] + data16[0]
//        }

//        print(wavelength)
        
        
    }
    
//    func convertInputValue<T: FixedWidthInteger>(_ inputValue: Data) -> T where T: CVarArg {
//        let stride = MemoryLayout<T>.stride
//        assert(inputValue.count % (stride / 2) == 0, "invalid pack size")
//
//        let fwInt = T.init(littleEndian: inputValue.withUnsafeBytes { $0.pointee })
//        let valuefwInt = String(format: "%0\(stride)x", fwInt).capitalized
//        print(valuefwInt)
//        return fwInt
//    }
    
    
    // Send Values
    
    
    // Control Characteristic (0x0010)
    // Up: 0x4700
    // Down: 0x4600
    // Stop: 0xFF00
    // ??: 0xFE00
    
    // ?? (0x0022)
    // ?: 0x0180
    // ?:
    
    // ?? (0x000D)
    // ?: 0x0200
    // ?:
    
    // ?? Characteristic (0x0013)
    // ?: 0x0100
    
    // ?? Characteristic (0x001B)
    // ?: 0x0100
    
    // ?? Characteristic (0x0017)
    // ?: 0x0100
    
    // ?? Characteristic (0x0016)
    // ?: 7F86 00
    // ?: 7F80 00
    // ?: 7F81 00
    // ?: 7F89 00
    // ?: 7F8A 00
    // ?: 7F8B 00
    // ?: 7F87 80D8 0B
    // ?: 7F89 00
    
    
    // Read values
    
    // Position Characteristic 0x001A ??
    // 7904 0000
    
}


//
//extension Data {
//    struct HexEncodingOptions: OptionSet {
//        let rawValue: Int
//        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
//    }
//
//    func hexEncodedString(options: HexEncodingOptions = []) -> String {
//        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
//        return map { String(format: format, $0) }.joined()
//    }
//}
