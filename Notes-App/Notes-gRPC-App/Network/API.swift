//
//  API.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Combine
import Foundation
import Grebe_Framework
import GRPC
import NIO

class API {
    typealias Note = NoteProto
    
//    private let client = GClient<NotesServiceServiceClient>(target: .hostAndPort("String", 4132))
    private let client: NotesServiceServiceClient
    
    init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let config = ClientConnection.Configuration(
            target: .hostAndPort("localhost", 4132),
            eventLoopGroup: group
        )
        let connection = ClientConnection(configuration: config)
        client = NotesServiceServiceClient(connection: connection)
    }
    
    func createNote(_ note: Note) -> AnyPublisher<CreateNoteResponse, Error> {
        var request = CreateNoteRequest()
        request.note = note
        
        let call = GUnaryCall(request: request, closure: client.createNote)
        return call.execute()
    }
    
    func getNotes() -> AnyPublisher<GetNotesResponse, Error> {
        let request = GetNotesRequest()
        let call = GServerStreamingCall(request: request, closure: client.getNotes)
        return call.execute()
    }
}
