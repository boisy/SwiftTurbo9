import Foundation

extension UInt8 {
    var asWord: UInt16 {
        UInt16(self)
    }
    
    var asSigned: Int8 {
        Int8(bitPattern: self)
    }
    
    var asSignedString: String {
        String(Int8(bitPattern: self))
    }

    var asUnsignedString: String {
        String(UInt8(self))
    }

    var asHex: String {
        String(format: "$%02hhX", self)
    }
    
    var asHexNoDollar: String {
        String(format: "%04hX", self)
    }
}
