import Foundation

private class Symbol {
    let label : String
    let file : String
    let address : UInt16
    
    init(label: String, file: String, address: UInt16) {
        self.label = label
        self.file = file
        self.address = address
    }
    
    init(line: String) {
        let tokens = line.components(separatedBy: " ")
        var theLabel = tokens[1]
        if theLabel.hasPrefix(".static.function.") {
            theLabel = String(theLabel.dropFirst(".static.function.".count))
        }
        if theLabel.hasPrefix(".local.static.") {
            theLabel = String(theLabel.dropFirst(".local.static.".count))
        }
        if theLabel.hasPrefix(".global.static.variable.") {
            theLabel = String(theLabel.dropFirst(".global.static.variable.".count))
        }
        self.label = theLabel
        self.file = tokens[2]
        self.address = UInt16(tokens[4], radix: 16)!
    }
}

public class Disassembler: Turbo9CPU {
    // MARK: - Private properties

    private var program: [UInt8] = []
    public var operations = [Turbo9Operation]()
    private var filePath : String = ""
    public var logging : Bool = true
    private var fileHandle : FileHandle?
    public var instructionClosure : ((String) -> Void)?
    var symbolTable : SymbolTable = SymbolTable()

    // MARK: - Init

    public init(program: [UInt8] = [], pc: UInt16 = 0x00) {
        self.program = program

        super.init(
            bus: Bus(memory: .createRam(withProgram: program)),
            pc: pc
        )
    }

    struct SymbolTable {
        fileprivate var symbols : [Symbol] = []
        
        init() {
            
        }
        
        init(symbolFileURL: URL) {
            do {
                let symbolFileContents = try String(contentsOf: symbolFileURL)
                let lines = symbolFileContents.components(separatedBy: .newlines)
                for line in lines {
                    if line.hasPrefix("Symbol:") {
                        symbols.append(Symbol(line: line))
                    }
                }
            } catch {
            }
        }

        func lookup(address : UInt16) -> String {
            for symbol in symbols {
                if symbol.address == address {
                    return symbol.label
                }
            }
            return ""
        }
    }

    public init(filePath: String, pc: UInt16 = 0x00, logging : Bool = true) {
        self.filePath = filePath
        let fileURL = URL(fileURLWithPath: self.filePath)
        do {
            program = try [UInt8](Data(contentsOf: fileURL))
        } catch {
            program = []
        }

        super.init(
            bus: Bus(memory: .createRam(withProgram: program)),
            pc: pc
        )
    }

    public func load(url : URL) throws {
        do {
            let program = try Data(contentsOf: url)
            symbolTable = SymbolTable(symbolFileURL: url.deletingPathExtension().appendingPathExtension("map"))
            self.program = [UInt8](program)
            let newRam = [UInt8].createRam(withProgram: self.program, loadAddress: UInt16(0x10000 - program.count))
            bus.memory = newRam
            bus.originalRam = newRam
            try self.reset()
        } catch {
            fatalError("Could not read file \(url)")
        }
    }
    
    public init(from url: URL, pc: UInt16 = 0x00) {
        do {
            let program = try Data(contentsOf: url)
            self.program = [UInt8](program)
        } catch {
            fatalError("Could not read file \(url)")
        }
        super.init(
            bus: Bus(memory: .createRam(withProgram: self.program)),
            pc: pc
        )
    }

    // MARK: - Internal methods

    public func disassemble(pc : UInt16 = UInt16.max) -> Turbo9Operation? {
        let oldPC = PC
        let oldA = A
        let oldB = B
        let oldDP = DP
        let oldCC = CC
        let oldX = X
        let oldY = Y
        let oldU = U
        let oldS = S

        var operation : Turbo9Operation? = nil
        let startPC = pc
        
        if pc != UInt16.max {
            PC = pc
        }
        
        if program.isWithinBounds(PC) {
            let offset = PC
            var prebyte : PreByte = .none, opcodeByte = readByte(PC)
            PC = PC &+ 1

            // Read byte and setup addressing mode.
            var opcode : OpCode?
            if opcodeByte == 0x10 {
                prebyte = .page10
                opcodeByte = readByte(PC)
                opcode = Self.opcodes10[Int(opcodeByte)]
                PC = PC &+ 1
            } else if opcodeByte == 0x11 {
                prebyte = .page11
                opcodeByte = readByte(PC)
                opcode = Self.opcodes11[Int(opcodeByte)]
                PC = PC &+ 1
            } else {
                opcode = Self.opcodes[Int(opcodeByte)]
            }
            if let opcode = opcode {
                let currentPC = PC
                setupAddressing(using: opcode.1)
                let pcOffset = PC &- currentPC &- 1
                
                let operand = getOperand(using: opcode.1, offset: pcOffset)
                var postOperand : PostOperand = PostOperand.none
                if opcode.1 == .ind {
                     // Since the postbyte dictates how many bytes follow, we do the processing here.
                    if pcOffset == 1 {
                        // There is one post operand byte
                        postOperand = PostOperand.byte(readByte(PC &- 1))
                    } else if pcOffset == 2 {
                        // There are two post operand bytes
                        postOperand = PostOperand.word(readWord(PC &- 2))
                    }
                } else {
                }

                let label = symbolTable.lookup(address: offset)
                if opcode.0 == .swi2 {
                    PC = PC &+ 1
                    let operand = getOperand(using: .imm8, offset: PC)
                    let os9 = OpCode(.swi2, .imm8, 1)
                    operation = Turbo9Operation(label: label, offset: offset, preByte: prebyte, opcode: opcodeByte, instruction: os9.0, addressMode: opcode.1, operand: operand, postOperand: postOperand, size: PC &- startPC)
                } else {
                    operation = Turbo9Operation(label: label, offset: offset, preByte: prebyte, opcode: opcodeByte, instruction: opcode.0, addressMode: opcode.1, operand: operand, postOperand: postOperand, size: PC &- startPC)
                }
            }
        }
        
        PC = oldPC
        A = oldA
        B = oldB
        X = oldX
        Y = oldY
        U = oldU
        S = oldS
        DP = oldDP
        CC = oldCC

        return operation
    }

    public func disassemble(instructionCount : UInt = 1, startPC : UInt16 = 0, restAPI : Bool = false) -> [String] {
        let oldPC = PC
        if restAPI == true {
            var tempPC = startPC
            var operations = [Turbo9Operation]()
            // This is being called outside of a running context.
            for _ in 0..<instructionCount {
                if let op = disassemble(pc: tempPC) {
                    tempPC = tempPC &+ UInt16(op.size)
                    operations.append(op)
                 }
            }
            PC = oldPC
            // Map operations to String and return it.
            return operations.map { $0.asCode }
        }
        for _ in 0..<instructionCount {
            if let op = disassemble(pc: PC) {
                PC = PC &+ UInt16(op.size)
                operations.append(op)
             }
        }
        PC = oldPC
        // Map operations to String and return it.
        return operations.map { $0.asCode }
    }

    private func registerLine() -> String {
        let A = String(format: "%02X", A)
        let B = String(format: "%02X", B)
        let DP = String(format: "%02X", DP)
        let CC = ccString
        let X = String(format: "%04X", X)
        let Y = String(format: "%04X", Y)
        let U = String(format: "%04X", U)
        let S = String(format: "%04X", S)
        return "A:\(A) B:\(B) DP:\(DP) CC:\(CC) X:\(X) Y:\(Y) U:\(U) S:\(S)"
    }
    
    public func step() throws -> Turbo9Operation? {
        var result : Turbo9Operation?
        var logLine = ""
        if syncToInterrupt == false {
            if let op = disassemble(pc: PC) {
                result = op
                logLine = op.asCode
            }
        }
        let syncToInterruptPre = syncToInterrupt
        try super.step()
        let syncToInterruptPost = syncToInterrupt
        if (syncToInterrupt == false || syncToInterruptPre != syncToInterruptPost) && logging == true {
            logLine = logLine.padding(toLength: 60, withPad: " ", startingAt: 0)
            let registers = registerLine()
            logLine += registers
            if let c = instructionClosure {
                c(logLine)
            }
        }
        
        return result
    }
    
    public func checkDisassembly(count : UInt = 30) -> [String] {
        var result : [String] = []
        if let last = operations.last, let first = operations.first {
            if PC >= last.offset || PC <= first.offset {
                operations = []
                result = disassemble(instructionCount: count, startPC: PC)
            }
        }
        return result
    }
    
    // MARK: - Private methods

    private func getOperand(using addressMode: AddressMode, offset: UInt16) -> Operand {
        switch addressMode {
        case .inh:
            return .none
        case .imm8:
            return .immediate8(readByte(PC &- 1))
        case .imm16:
            return .immediate16(readWord(PC &- 2))
        case .dir:
            return .direct(readByte(PC &- 1))
        case .ext:
            return .extended(readWord(PC &- 2))
        case .ind:
            return .indexed(readByte(PC &- 1 &- offset))
        case .rel8:
            return .relative8(readByte(PC &- 1))
        case .rel16:
            return .relative16(readWord(PC &- 2))
        }
    }
}
