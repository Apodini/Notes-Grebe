import GRPC
import NIO
import Logging
import SwiftProtobuf

LoggingSystem.bootstrap { label in
  var handler = StreamLogHandler.standardOutput(label: label)
  handler.logLevel = .debug
  return handler
}

func main(args: [String]) throws {
    let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    defer {
        try! group.syncShutdownGracefully()
    }
    
    let provider = NotesServerProvider()
    
    let configuration = Server.Configuration(
        target: .hostAndPort("localhost", 0),
        eventLoopGroup: group,
        serviceProviders: [provider]
    )
    
    let server = Server.start(configuration: configuration)
    server.map {
        $0.channel.localAddress
    }.whenSuccess { address in
        print("server started on port \(address!.port!)")
    }

    _ = try server.flatMap {
        $0.onClose
    }.wait()
}

try main(args: CommandLine.arguments)
