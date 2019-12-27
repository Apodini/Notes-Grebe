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
    
    private let client = GClient<NotesServiceServiceClient>(target: .hostAndPort("localhost", 53118))
    
    func createNote(_ note: Note) -> AnyPublisher<CreateNoteResponse, GRPCStatus> {
        var request = CreateNoteRequest()
        request.note = note
        
        let call = GUnaryCall(
            request: GRequestMessage(request),
            closure: client.service.createNote
        )
        return call.execute()
    }
    
    func getNotes() -> AnyPublisher<GetNotesResponse, GRPCStatus> {
        let request = GetNotesRequest()
        let call = GServerStreamingCall(
            request: GRequestMessage(request),
            closure: client.service.getNotes
        )
        return call.execute()
    }
    
    func deleteNotes(_ notes: [Note]) -> AnyPublisher<DeleteNotesResponse, GRPCStatus> {
        let requests = Publishers.Sequence<[DeleteNotesRequest], Error>(
            sequence: notes.map { note in DeleteNotesRequest.with { $0.note = note }}
        ).eraseToAnyPublisher()
        
        let call = GClientStreamingCall(
            request: GRequestStream(requests),
            closure: client.service.deleteNotes
        )
        return call.execute()
    }
    
    func switchTitleContent(notes: [Note]) -> AnyPublisher<SwitchTitleContentResponse, GRPCStatus> {
        let requests = Publishers.Sequence<[SwitchTitleContentRequest], Error>(
            sequence: notes.map { note in SwitchTitleContentRequest.with { $0.note = note }}
        ).eraseToAnyPublisher()
        
        let call = GBidirectionalStreamingCall(
            request: GRequestStream(requests),
            closure: client.service.switchTitleContent
        )
        return call.execute()
    }
}

// TODO: Has to be generated
extension NotesServiceServiceClient: GRPCClientInitializable {}
