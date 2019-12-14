//
//  NotesServerProvider.swift
//
//
//  Created by Tim Mewe on 14.12.19.
//

import Foundation
import GRPC
import NIO
import NIOConcurrencyHelpers

class NotesServerProvider: NotesServiceProvider {
    typealias Note = NoteProto
    
    private var notes = [String: Note]()
    
    init(notes: [Note] = []) {
        notes.forEach { self.notes[$0.id] = $0 }
    }
    
    func createNote(request: CreateNoteRequest, context: StatusOnlyCallContext) -> EventLoopFuture<CreateNoteResponse> {
        print("=== CREATE NOTE ===")
        let note = request.note
        notes[note.id] = note
        return context.eventLoop.makeSucceededFuture(CreateNoteResponse())
    }
    
    func deleteNotes(context: UnaryResponseCallContext<DeleteNotesResponse>) -> EventLoopFuture<(StreamEvent<DeleteNotesRequest>) -> Void> {
        
    }
    
    func getNotes(request: GetNotesRequest, context: StreamingResponseCallContext<GetNotesResponse>) -> EventLoopFuture<GRPCStatus> {
        notes
            .map {
                var response = GetNotesResponse()
                response.note = $0
                return response
            }
            .forEach {
                _ = context.sendResponse($0)
            }
        return context.eventLoop.makeSucceededFuture(.ok)
    }
    
    func switchTitleContent(context: StreamingResponseCallContext<SwitchTitleContentResponse>) -> EventLoopFuture<(StreamEvent<SwitchTitleContentRequest>) -> Void> {}
}
