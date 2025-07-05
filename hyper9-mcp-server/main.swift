import MCP
import `Vapor`

enum Main {
    static func main() async throws {
        struct Post: Content {
            let register: String
            let value: String
        }

        func getRegisters(app: Application) async throws -> [Post] {
            let response = try await app.client.get("https://localhost:8080/registers")
            return try response.content.decode([Post].self)
        }

        let app = try Application(.development)

        // Configure routes
        app.get("hello") { req async in
            "Hello, Vapor!"
        }

        // MCP server setup
        let server = Server(
            name: "Hyper9Server",
            version: "1.0.0",
            capabilities: .init(
                prompts: .init(listChanged: true),
                resources: .init(subscribe: true, listChanged: true),
                tools: .init(listChanged: true)
            )
        )

        let transport = StdioTransport()

        // MCP: List tools
        await server.withMethodHandler(ListTools.self) { _ in
            .init(tools: [
                Tool(name: "registers", description: "Get Turbo9 register state in the Hyper9 simulator.")
            ])
        }

        // MCP: Tool handler
        await server.withMethodHandler(CallTool.self) { params in
            switch params.name {
            case "registers":
                do {
                    let registers = try await getRegisters(app: app)
                    let text = registers.map { "\($0.register): \($0.value)" }.joined(separator: ", ")
                    return .init(content: [.text("Registers: \(text)")], isError: false)
                } catch {
                    return .init(content: [.text("Error: \(error.localizedDescription)")], isError: true)
                }
            default:
                return .init(content: [.text("Unknown tool")], isError: true)
            }
        }

        // Run both Vapor and MCP concurrently
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { try await app.execute() }
            group.addTask {
                try await server.start(transport: transport) { clientInfo, _ in
                    guard clientInfo.name != "BlockedClient" else {
                        throw MCPError.invalidRequest("Blocked")
                    }
                    print("Client \(clientInfo.name) v\(clientInfo.version) connected")
                }
            }
            try await group.waitForAll()
        }
    }
}

try await Main.main()
