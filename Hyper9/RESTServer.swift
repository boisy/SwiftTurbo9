//
//  RESTServer.swift
//  Hyper9
//
//  Created by Boisy Pitre on 6/6/25.
//

import Vapor
import Foundation
import Turbo9Sim

public struct Turbo9OperationResult : Content, Encodable {
    var operation : String
    var registers : String
}

final class RESTServer: @unchecked Sendable {
    private let model: Turbo9ViewModel
    private var app: Application?

    init(model: Turbo9ViewModel) {
        self.model = model
    }

    public func start() {
        Task {
            let sanitizedArgs = [CommandLine.arguments[0]]
            let env = Environment(name: "development", arguments: sanitizedArgs)
            let app = try await Application.make(env)
            self.app = app

            // /registers
            app.get("registers") { req -> Response in
                let registers = self.model.turbo9.registers
                let json = try JSONEncoder().encode(registers)
                return Response(status: .ok, body: .init(data: json))
            }

            // /disasm?addr=2000&len=8
            app.get("disasm") { req -> Response in
                let addrStr = req.query["addr"] ?? String(self.model.turbo9.PC, radix: 16)
                let countStr = req.query["count"] ?? "1"
                guard let addr = UInt16(addrStr, radix: 16),
                      let count = UInt(countStr) else {
                    throw Abort(.badRequest, reason: "Invalid addr or count")
                }

                let disasmLines = self.model.turbo9.disassemble(instructionCount: count, startPC: addr, restAPI: true)
                let json = try JSONEncoder().encode(disasmLines)
                return Response(status: .ok, body: .init(data: json))
            }

            // /memdump?addr=2000&len=16
            app.get("memdump") { req -> Response in
                let addrStr = req.query["addr"] ?? "0"
                let lenStr = req.query["len"] ?? "16"
                guard let addr = UInt16(addrStr, radix: 16),
                      let len = Int(lenStr) else {
                    throw Abort(.badRequest, reason: "Invalid addr or len")
                }

                let dump = self.model.turbo9.dumpMemory(address: UInt32(addr), count: len)
                let json = try JSONEncoder().encode(dump)
                return Response(status: .ok, body: .init(data: json))
            }

            // /step
            app.get("step") { req -> Response in
                let _ = self.model.step()
                return Response(status: .ok)
            }

            do {
                try await app.execute()
            } catch {
                print("REST API failed to start: \(error)")
            }
        }
    }
}
