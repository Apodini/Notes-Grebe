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
    
    private let client = GClient<NotesServiceServiceClient>(target: .hostAndPort("localhost", 56729))
    
    func createNote(_ note: Note) -> AnyPublisher<CreateNoteResponse, GRPCStatus> {
        var request = CreateNoteRequest()
        request.note = note
        
        let call = GUnaryCall(request: request, closure: client.service.createNote)
        return call.execute()
    }
    
    func getNotes() -> AnyPublisher<GetNotesResponse, GRPCStatus> {
        let request = GetNotesRequest()
        let call = GServerStreamingCall(request: request, closure: client.service.getNotes)
        return call.execute()
    }
}

// TODO: Has to be generated
extension NotesServiceServiceClient: GRPCClientInitializable {}
