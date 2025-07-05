import Foundation

extension Turbo9CPU {
    typealias ShouldIncludeExtraClockCycles = Bool

    @discardableResult
    func perform(instruction: Instruction, addressMode: AddressMode) throws -> ShouldIncludeExtraClockCycles {
        switch instruction {
        case .xxx: false
        case .abx: abx(addressMode: addressMode)
        case .adca: adca(addressMode: addressMode)
        case .adcb: adcb(addressMode: addressMode)
        case .adda: adda(addressMode: addressMode)
        case .addb: addb(addressMode: addressMode)
        case .addd: addd(addressMode: addressMode)
        case .anda: anda(addressMode: addressMode)
        case .andb: andb(addressMode: addressMode)
        case .andcc: andcc(addressMode: addressMode)
        case .asl: asl(addressMode: addressMode)
        case .asla: asla(addressMode: addressMode)
        case .aslb: aslb(addressMode: addressMode)
        case .asr: asr(addressMode: addressMode)
        case .asra: asra(addressMode: addressMode)
        case .asrb: asrb(addressMode: addressMode)
        case .bcc: bcc(addressMode: addressMode)
        case .bhs: bcc(addressMode: addressMode)
        case .bcs: bcs(addressMode: addressMode)
        case .beq: beq(addressMode: addressMode)
        case .bge: bge(addressMode: addressMode)
        case .bgt: bgt(addressMode: addressMode)
        case .bhi: bhi(addressMode: addressMode)
        case .ble: ble(addressMode: addressMode)
        case .blo: bcs(addressMode: addressMode)
        case .bls: bls(addressMode: addressMode)
        case .blt: blt(addressMode: addressMode)
        case .bita: bita(addressMode: addressMode)
        case .bitb: bitb(addressMode: addressMode)
        case .bmi: bmi(addressMode: addressMode)
        case .bne: bne(addressMode: addressMode)
        case .bpl: bpl(addressMode: addressMode)
        case .bra: bra(addressMode: addressMode)
        case .brn: brn(addressMode: addressMode)
        case .bsr: bsr(addressMode: addressMode)
        case .bvc: bvc(addressMode: addressMode)
        case .bvs: bvs(addressMode: addressMode)
        case .clra: clra(addressMode: addressMode)
        case .clrb: clrb(addressMode: addressMode)
        case .clr: clr(addressMode: addressMode)
        case .cmpa: cmpa(addressMode: addressMode)
        case .cmpb: cmpb(addressMode: addressMode)
        case .cmpd: cmpd(addressMode: addressMode)
        case .cmpx: cmpx(addressMode: addressMode)
        case .cmpy: cmpy(addressMode: addressMode)
        case .cmpu: cmpu(addressMode: addressMode)
        case .cmps: cmps(addressMode: addressMode)
        case .coma: coma(addressMode: addressMode)
        case .comb: comb(addressMode: addressMode)
        case .com: com(addressMode: addressMode)
        case .cwai: cwai(addressMode: addressMode)
        case .daa: daa(addressMode: addressMode)
        case .deca: deca(addressMode: addressMode)
        case .decb: decb(addressMode: addressMode)
        case .dec: dec(addressMode: addressMode)
        case .eora: eora(addressMode: addressMode)
        case .eorb: eorb(addressMode: addressMode)
        case .exg: try exg(addressMode: addressMode)
        case .inca: inca(addressMode: addressMode)
        case .incb: incb(addressMode: addressMode)
        case .inc: inc(addressMode: addressMode)
        case .jmp: jmp(addressMode: addressMode)
        case .jsr: jsr(addressMode: addressMode)
        case .lbcc: lbcc(addressMode: addressMode)
        case .lbcs: lbcs(addressMode: addressMode)
        case .lblo: lbcs(addressMode: addressMode)
        case .lbvc: lbvc(addressMode: addressMode)
        case .lbvs: lbvs(addressMode: addressMode)
        case .lbeq: lbeq(addressMode: addressMode)
        case .lbge: lbge(addressMode: addressMode)
        case .lbgt: lbgt(addressMode: addressMode)
        case .lbhi: lbhi(addressMode: addressMode)
        case .lbhs: lbcc(addressMode: addressMode)
        case .lble: lble(addressMode: addressMode)
        case .lbls: lbls(addressMode: addressMode)
        case .lblt: lblt(addressMode: addressMode)
        case .lbmi: lbmi(addressMode: addressMode)
        case .lbne: lbne(addressMode: addressMode)
        case .lbpl: lbpl(addressMode: addressMode)
        case .lbra: lbra(addressMode: addressMode)
        case .lbrn: lbrn(addressMode: addressMode)
        case .lbsr: lbsr(addressMode: addressMode)
        case .lda: lda(addressMode: addressMode)
        case .ldb: ldb(addressMode: addressMode)
        case .ldd: ldd(addressMode: addressMode)
        case .ldx: ldx(addressMode: addressMode)
        case .ldy: ldy(addressMode: addressMode)
        case .ldu: ldu(addressMode: addressMode)
        case .lds: lds(addressMode: addressMode)
        case .leax: leax(addressMode: addressMode)
        case .leay: leay(addressMode: addressMode)
        case .leau: leau(addressMode: addressMode)
        case .leas: leas(addressMode: addressMode)
        case .lsla: lsla(addressMode: addressMode)
        case .lslb: lslb(addressMode: addressMode)
        case .lsl: lsl(addressMode: addressMode)
        case .lsra: lsra(addressMode: addressMode)
        case .lsrb: lsrb(addressMode: addressMode)
        case .lsr: lsr(addressMode: addressMode)
        case .mul: mul(addressMode: addressMode)
        case .nega: nega(addressMode: addressMode)
        case .negb: negb(addressMode: addressMode)
        case .neg: neg(addressMode: addressMode)
        case .nop: nop(addressMode: addressMode)
        case .ora: ora(addressMode: addressMode)
        case .orb: orb(addressMode: addressMode)
        case .orcc: orcc(addressMode: addressMode)
        case .pshs: pshs(addressMode: addressMode)
        case .pshu: pshu(addressMode: addressMode)
        case .puls: puls(addressMode: addressMode)
        case .pulu: pulu(addressMode: addressMode)
        case .rola: rola(addressMode: addressMode)
        case .rolb: rolb(addressMode: addressMode)
        case .rol: rol(addressMode: addressMode)
        case .rora: rora(addressMode: addressMode)
        case .rorb: rorb(addressMode: addressMode)
        case .ror: ror(addressMode: addressMode)
        case .rti: rti(addressMode: addressMode)
        case .rts: rts(addressMode: addressMode)
        case .sbca: sbca(addressMode: addressMode)
        case .sbcb: sbcb(addressMode: addressMode)
        case .sbcd: sbcd(addressMode: addressMode)
        case .sex: sex(addressMode: addressMode)
        case .sta: sta(addressMode: addressMode)
        case .stb: stb(addressMode: addressMode)
        case .std: std(addressMode: addressMode)
        case .stx: stx(addressMode: addressMode)
        case .sty: sty(addressMode: addressMode)
        case .stu: stu(addressMode: addressMode)
        case .sts: sts(addressMode: addressMode)
        case .suba: suba(addressMode: addressMode)
        case .subb: subb(addressMode: addressMode)
        case .subd: subd(addressMode: addressMode)
        case .swi: swi(addressMode: addressMode)
        case .swi2: swi2(addressMode: addressMode)
        case .swi3: swi3(addressMode: addressMode)
        case .sync: sync(addressMode: addressMode)
        case .tfr: try tfr(addressMode: addressMode)
        case .tsta: tsta(addressMode: addressMode)
        case .tstb: tstb(addressMode: addressMode)
        case .tst: tst(addressMode: addressMode)
        }
    }
}

extension Turbo9CPU {
    /// Decimal addition adjust.
    ///
    /// ```
    /// A[4..7]’ ← A[4..7] + 6 IF:
    /// CC.C = 1
    /// OR: A[4..7] > 9
    /// OR: A[4..7] > 8 AND A[0..3] > 9
    /// A[0..3]’ ← A[0..3] + 6 IF:
    /// CC.H = 1
    /// OR: A[0..3] > 9
    /// ```
    ///
    /// The sequence of a single-byte add instruction on accumulator `A` (either `ADDA` or `ADCA`) and a following decimal addition adjust instruction results in a BCD addition with an appropriate carry bit. Both values to be added must be in proper BCD form (each nibble such that: 0 ≤ nibble ≤ 9). Multiple-precision addition must add the carry generated by this decimal addition adjust into the next higher digit during the add operation (`ADCA`) immediately prior to the next decimal addition adjust.
    ///
    /// Addressing modes:
    /// - Inherent
    ///
    /// Condition codes:
    /// - H    -    Not affected.
    /// - N    -    Set if the result is negative; cleared otherwise.
    /// - Z    -    Set if the result is zero; cleared otherwise.
    /// - V    -    Undefined.
    /// - C    -    Set if a carry is generated or if the carry bit was set before the operation; cleared otherwise.
    func daa(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        var setCarry = false
        
        var upperNibble = A & 0xF0 >> 4
        var lowerNibble = A & 0x0F
        if readCC(.carry) == true || upperNibble > 9 || (upperNibble > 8 && lowerNibble > 0) {
            if upperNibble > 10 {
                setCarry = true
            }
            upperNibble += 6
        }
        if readCC(.halfcarry) == true || lowerNibble > 9 {
            if lowerNibble > 10 {
                setCarry = true
            }
            lowerNibble += 6
        }
        A = upperNibble << 4 | lowerNibble
        
        setNegativeFlag(using: A)
        setZeroFlag(using: A)
        setCC(.carry, setCarry)

        return false
    }

 
    /// Perform an unsigned multiply.
    ///
    /// ```
    /// A':B' ← A × B
    /// ```
    ///
    /// This instruction multiply the unsigned binary numbers in the accumulators and place the result in both accumulators (`A` contains the most-significant byte of the result). Unsigned multiply allows multiple-precision operations.
    ///
    /// Addressing Modes:
    /// - Inherent
    ///
    /// Condition codes:
    /// - H    -    Not affected.
    /// - N    -    Not affected.
    /// - Z    -    Set if the result is zero; cleared otherwise.
    /// - V    -    Not affected.
    /// - C    -    Set if `B` bit 7 of result is set; cleared otherwise.
    func mul(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        // Perform multiplication
        let result = UInt16(A) * UInt16(B)
        
        // Convert result to unsigned 16-bit to extract high and low bytes.
        let _ = UInt8(result >> 8)
        let lowByte = UInt8(result & 0xFF)
        
        // Store the high and low bytes back into acca and accb.A =highByte
        B = lowByte

        // Update flags based on the result.
        setZeroFlag(using: result)
        setCC(.carry, (B & 0x80) == 0x80)

        return true
    }

    /// No operation.
    func nop(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        return false
    }

    /// Return from interrupt.
    ///
    /// Pull regsiters and return from an interrupt.
    ///
    /// The saved machine state is recovered from the system stack and control is returned to the interrupted program. If the recovered `E` (entire) bit is clear, it indicates that only a subset of the machine state was saved (return address and condition codes) and only that subset is recovered.
    ///
    /// Addressing Mode:
    /// - Inherent
    ///
    /// Condition codes: Recovered from stack.
    func rti(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        CC = pullByteFromS()
        if readCC(.entire) == true {A = pullByteFromS()
            B = pullByteFromS()
            DP = pullByteFromS()
            X = pullWordFromS()
            Y = pullWordFromS()
            U = pullWordFromS()
        }
        PC = pullWordFromS()

        return false
    }

    /// Return from subroutine.
    ///
    /// ```
    /// PC’ ← (S:S+1)
    /// S’ ← S + 2
    /// ```
    ///
    /// Program control is returned from the subroutine to the calling program. The return address is pulled from the stack.
    ///
    /// Addressing mode:
    /// - Inherent
    ///
    /// Condition Codes: Not affected.
    func rts(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        PC = pullWordFromS()

        return false
    }
}

// MARK: - Private methods

// MARK: - Increment and decrement

extension Turbo9CPU {
    enum IncrementOrDecrement {
        case inc
        case dec
    }
    
    func perform(_ op: IncrementOrDecrement, on value: UInt8) -> UInt8 {
        let result: UInt8
        switch op {
        case .inc:
            result = value &+ 1
        case .dec:
            result = value &- 1
        }
        
        setZeroFlag(using: result)
        setNegativeFlag(using: result)
        
        return result
    }
    
    func perform(_ op: IncrementOrDecrement, on value: UInt16) -> UInt16 {
        let result: UInt16
        switch op {
        case .inc:
            result = value &+ 1
        case .dec:
            result = value &- 1
        }

        setZeroFlag(using: result)
        setNegativeFlag(using: result)

        return result
    }
}

// MARK: - Stack operations

extension Turbo9CPU {
    func pushToS(byte: UInt8) {
        S = S &- 1
        writeByte(S, data: byte)
    }
    
    func pushToS(word: UInt16) {
        pushToS(byte: word.lowByte)
        pushToS(byte: word.highByte)
    }
    
    func pullByteFromS() -> UInt8 {
        let result = readByte(S)
        S = S &+ 1
        return result
    }
    
    func pullWordFromS() -> UInt16 {
        let highByte = pullByteFromS()
        let lowByte = pullByteFromS()
        return .createWord(highByte: highByte, lowByte: lowByte)
    }
    
    func pushToU(byte: UInt8) {
        U = U &- 1
        writeByte(U, data: byte)
    }

    func pushToU(word: UInt16) {
        pushToU(byte: word.lowByte)
        pushToU(byte: word.highByte)
    }

    func pullByteFromU() -> UInt8 {
        let result = readByte(U)
        U = U &+ 1
        return result
    }

    func pullWordFromU() -> UInt16 {
        let highByte = pullByteFromU()
        let lowByte = pullByteFromU()
        return .createWord(highByte: highByte, lowByte: lowByte)
    }
}

// MARK: - Flag operations

extension Turbo9CPU {
    func setZeroFlag(using value: UInt8) {
        setCC(.zero, value == 0x00)
    }

    func setZeroFlag(using value: UInt16) {
        setCC(.zero, value == 0x00)
    }

    func setNegativeFlag(using value: UInt8) {
        setCC(.negative, value & 0x80 == 0x80)
    }

    func setNegativeFlag(using value: UInt16) {
        setCC(.negative, value & 0x8000 == 0x8000)
    }
}
