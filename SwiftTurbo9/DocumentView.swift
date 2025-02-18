//
//  DocumentView.swift
//  SwiftTurbo9
//
//  Created by Boisy Pitre on 1/22/25.
//

import SwiftUI
import Turbo9Sim
import UniformTypeIdentifiers

struct DocumentView: View {
    // Bind to the document so changes are automatically saved.
    @Binding var document: SimDocument
    @EnvironmentObject var model: Turbo9ViewModel

    var body: some View {
        HStack {
            VStack {
                MemoryView()
                TerminalView()
            }
            .frame(width:640, height: 640)

            VStack {
            }

            VStack {
                RegisterView()
                ZStack {
                    if model.running == true {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Optional: makes the spinner larger
                            .padding()
                    }
                    DisassemblyView()
                }
                ControlView()
                StatisticsView()
            }
            .padding()
            .task {
                let _ = model.disassemble(instructionCount: 2)
                model.updateUI()
            }
        }
        .onAppear() {
        }
        .onReceive(model.$PC) { newValue in
//            model.turbo9.checkDisassembly()
        }
    }
}


class Turbo9ViewModel: ObservableObject {
    @Published var A: UInt8 = 0x00
    @Published var B: UInt8 = 0x00
    @Published var DP: UInt8 = 0x00
    @Published var X: UInt16 = 0x0000
    @Published var Y: UInt16 = 0x0000
    @Published var U: UInt16 = 0x0000
    @Published var S: UInt16 = 0x0000
    @Published var PC: UInt16 = 0x0000
    @Published var ccString: String = ""
    @Published var instructionsExecuted: UInt = 0
    @Published var interruptsReceived: UInt = 0
    @Published var operations: [Disassembler.Turbo9Operation] = []
    @Published var memoryDump: String = ""
    public var turbo9 = Disassembler(program: [UInt8].init(repeating: 0x00, count: 65536), logPath: "/Users/boisy/turbo9.log")
    public var updateUI: (() -> Void) = {}
    public var output : UInt8 = 0
    @Published public var outputString = ""
    private var outputBuffer = ""
    @Published var running = false
    public var timerRunning = false

    func disassemble(instructionCount: UInt) {
        let _ = turbo9.disassemble(instructionCount: instructionCount)
        updateUI()
    }
    
    func step() {
        do {
            try turbo9.step()
        } catch {
            
        }
    }

    func load(url: URL) {
        do {
            try turbo9.load(url: url)
            outputString = ""
            updateUI()
        } catch {
            
        }
    }

    func reset() {
        do {
            try turbo9.reset()
        } catch {
            
        }
    }

    public func invokeTimer() {
        // Set the bit indicating the timer has fired
        let value = turbo9.bus.read(0xFF01)
        turbo9.bus.write(0xFF01, data: value | 0x01)
        
        // If the timer control register's "interrupt on timer fire" is set, assert the IRQ
        if (turbo9.bus.read(0xFF02) & 0x01) == 0x01 {
            turbo9.assertIRQ()
        }
    }

    init() {
        let outputHandler = BusWriteHandler(address: 0xFF00, callback: { value in
            self.outputBuffer += String(format: "%c", value)
            DispatchQueue.main.sync {
                self.updateUI()
            }
        })

        let timerHandler = BusWriteHandler(address: 0xFF02, callback: { value in
            if (value & 0x01) == 0x01 {
                self.timerRunning = true
            }
        })

        reset()
        turbo9.bus.addWriteHandler(handler: outputHandler)
        turbo9.bus.addWriteHandler(handler: timerHandler)
        
        // Set the model’s update callback to update the published property.
        updateUI = { [weak self] in
            // Make sure to update on the main thread.
//            DispatchQueue.main.async {
                if let self = self {
                    self.A = self.turbo9.A
                    self.B = self.turbo9.B
                    self.DP = self.turbo9.DP
                    self.X = self.turbo9.X
                    self.Y = self.turbo9.Y
                    self.U = self.turbo9.U
                    self.S = self.turbo9.S
                    self.ccString = self.turbo9.ccString
                    self.PC = self.turbo9.PC
                    self.instructionsExecuted = self.turbo9.instructionsExecuted
                    self.interruptsReceived = self.turbo9.interruptsReceived
                    self.memoryDump = self.turbo9.memoryDump
                    self.operations = self.turbo9.operations
                    self.outputString = self.outputBuffer
                }
//            }
        }
    }

    func startTask() {
        do {
            try turbo9.step()
            updateUI()
        } catch {
            
        }
    }
}


#Preview {
    let model = Turbo9ViewModel()
    DocumentView(document: .constant(SimDocument()))
        .environmentObject(model)
}
