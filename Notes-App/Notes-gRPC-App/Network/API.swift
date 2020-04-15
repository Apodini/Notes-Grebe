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
import Grebe_Generated
import GRPC

typealias Note = NoteProto
extension NoteProto: Identifiable {}

class API {
    private let client = GClient<NotesServiceServiceClient>(
        target: .hostAndPort("localhost", 55214)
    )
    
    func createNote(_ note: Note) -> AnyPublisher<CreateNoteResponse, GRPCStatus> {
        var request = CreateNoteRequest()
        request.note = note
        return client.service.createNote(request: request)
    }
    
    func getNotes() -> AnyPublisher<GetNotesResponse, GRPCStatus> {
        client.service.getNotes(request: GetNotesRequest())
    }
    
    func deleteNotes(_ notes: [Note]) -> AnyPublisher<DeleteNotesResponse, GRPCStatus> {
        let requests = Publishers.Sequence<[DeleteNotesRequest], Error>(
            sequence: notes.map { note in DeleteNotesRequest.with { $0.note = note } }
        ).eraseToAnyPublisher()
        return client.service.deleteNotes(request: requests)
    }
    
    func switchTitleContent(notes: [Note]) -> AnyPublisher<SwitchTitleContentResponse, GRPCStatus> {
        let requests = Publishers
            .Sequence<[SwitchTitleContentRequest], Error>(
                sequence: notes.map { note in
                    SwitchTitleContentRequest.with { $0.note = note }
                }
            ).eraseToAnyPublisher()
        return client.service.switchTitleContent(request: requests)
    }
}
