//
//  Extensions.swift
//  Desk Controller
//
//  Created by David Williames on 11/1/21.
//

import Foundation

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

extension Float {
    
    /// Convert from centimeters to inches
    func convertToInches() -> Float {
        let centimeterMeasurement = Measurement(value: Double(self), unit: UnitLength.centimeters)
        let inchesMeasurement = centimeterMeasurement.converted(to: UnitLength.inches)
        return Float(inchesMeasurement.value)
    }
    
    /// Convert from inches to centimeters
    func convertToCentimeters() -> Float {
        let inchesMeasurement = Measurement(value: Double(self), unit: UnitLength.inches)
        let centimeterMeasurement = inchesMeasurement.converted(to: UnitLength.centimeters)
        return Float(centimeterMeasurement.value)
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }

}

extension Date {
    public var nextHour: Date {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: self)
        let components = DateComponents(hour: 1, minute: -minutes)
        return calendar.date(byAdding: components, to: self) ?? self
    }
}
