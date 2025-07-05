import Foundation

extension Turbo9CPU {
    /// Retrieve the value of a 16-bit register.
    private func getRegister16(_ reg: Register) throws -> UInt16 {
        switch reg {
        case .D:
            return D
        case .X:
            return X
        case .Y:
            return Y
        case .U:
            return U
        case .SP:
            return S
        default:
            throw CPUError.invalidRegister
        }
    }
    
    /// Set the value of a 16-bit register.
    private func setRegister16(_ reg: Register, value: UInt16) throws {
        switch reg {
        case .D:
            D = value
        case .X:
            X = value
        case .Y:
            Y = value
        case .U:
            U = value
        case .SP:
            S = value
        default:
            throw CPUError.invalidRegister
        }
    }
    
    /// Retrieve the value of an 8-bit register.
    private func getRegister8(_ reg: Register) throws -> UInt8 {
        switch reg {
        case .A:
            return A
        case .B:
            return B
        case .CC:
            return CC
        case .DP:
            return DP
        default:
            throw CPUError.invalidRegister
        }
    }
    
    /// Set the value of an 8-bit register.
    private func setRegister8(_ reg: Register, value: UInt8) throws {
        switch reg {
        case .A:A = value
        case .B:
            B = value
        case .CC:
            CC = value
        case .DP:
            DP = value
        default:
            throw CPUError.invalidRegister
        }
    }

    /// CPU errors.
    enum CPUError: Error, CustomStringConvertible {
        case invalidRegister
        case mismatchedRegisterTypes
        case invalidMemorySize

        var description: String {
            switch self {
            case .invalidRegister:
                return "Invalid register specified."
            case .mismatchedRegisterTypes:
                return "Registers are of different types and cannot be exchanged."
            case .invalidMemorySize:
                return "The memory size requested is too large."
            }
        }
    }
    
    /// Transfer register to register.
    ///
    /// ```
    /// r0 → r1
    /// ```
    ///
    /// Transfers data between two designated registers. Bits 7-4 of the postbyte define the source register, while bits 3-0 define the destination register.
    ///
    /// Addressing modes:
    /// - Immediate
    ///
    /// Condition codes: Not affected unless R2 is the condition code register.
    func tfr(addressMode: AddressMode) throws -> ShouldIncludeExtraClockCycles {
        var postByte: UInt8
        
        postByte = readByte(addressAbsolute)
        
        let r1 = Int((postByte & 0xF0) >> 4)
        let r2 = Int(postByte & 0x0F)
        
        let reg1 = Register.registerMapping(r1)
        let reg2 = Register.registerMapping(r2)
        
        // TODO: Redo this logic since 8/16 bit transfer mismatches CAN occur.
        // Ensure both registers are of the same type.
        guard reg1.type == reg2.type else {
            throw CPUError.mismatchedRegisterTypes
        }

        switch reg1.type {
        case .eightBit:
            // Transfer 8-bit registers.
            let val1 = try getRegister8(reg1)
            try setRegister8(reg2, value: val1)
        case .sixteenBit:
            // Transfer 16-bit registers.
            let val1 = try getRegister16(reg1)
            try setRegister16(reg2, value: val1)
        }

        return false
    }
}
