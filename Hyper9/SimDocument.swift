import SwiftUI
import UniformTypeIdentifiers

// Define your document type.
struct SimDocument: FileDocument {
    // The document’s content; adjust as needed.
    var disassembler = Turbo9ViewModel()
    var text: String = "Hello, SwiftUI Document App!"
    let server : RESTServer?

    // Specify the content types that your document supports.
    static var readableContentTypes: [UTType] { [.plainText] }

    // A default initializer for new documents.
    init() {
        server = RESTServer(model: disassembler)
        server!.start()
    }

    // Initialize from a file configuration.
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents,
           let fileContents = String(data: data, encoding: .utf8) {
            text = fileContents
            server = RESTServer(model: disassembler)
            server!.start()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // Write the document's data into a FileWrapper.
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
}
