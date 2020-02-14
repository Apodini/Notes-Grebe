//
//  API.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Combine
import Foundation
import Grebe
import Grebe_Framework
import GRPC

class API {
    typealias Note = NoteProto
    
    let client = NotesServiceServiceClient(
        connection: ClientConnection(
            configuration: ClientConnection.Configuration(
                target: .hostAndPort("localhost", 62602),
                eventLoopGroup: PlatformSupport.makeEventLoopGroup(loopCount: 1)
            )
        )
    )
    
    func createNote(_ note: Note) -> AnyPublisher<CreateNoteResponse, GRPCStatus> {
        var request = CreateNoteRequest()
        request.note = note
        return client.createNote(request: request)
    }
    
    func getNotes() -> AnyPublisher<GetNotesResponse, GRPCStatus> {
        client.getNotes(request: GetNotesRequest())
    }
    
    func deleteNotes(_ notes: [Note]) -> AnyPublisher<DeleteNotesResponse, GRPCStatus> {
        let requests = Publishers.Sequence<[DeleteNotesRequest], Error>(
            sequence: notes.map { note in DeleteNotesRequest.with { $0.note = note } }
        ).eraseToAnyPublisher()
        return client.deleteNotes(request: requests)
    }
    
    func switchTitleContent(notes: [Note]) -> AnyPublisher<SwitchTitleContentResponse, GRPCStatus> {
        let requests = Publishers.Sequence<[SwitchTitleContentRequest], Error>(
            sequence: notes.map { note in SwitchTitleContentRequest.with { $0.note = note } }
        ).eraseToAnyPublisher()
        return client.switchTitleContent(request: requests)
    }
}
