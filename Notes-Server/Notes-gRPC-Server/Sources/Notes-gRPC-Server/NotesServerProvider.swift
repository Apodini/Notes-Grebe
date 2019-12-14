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
        return context.eventLoop.makeSucceededFuture({ [weak self] event in
            switch event {
            case .message(let request):
                let noteToDelete = request.note
                _ = self?.notes.removeValue(forKey: noteToDelete.id)
                
            case .end:
                context.responsePromise.succeed(DeleteNotesResponse())
            }
        })
    }
    
    func getNotes(request: GetNotesRequest, context: StreamingResponseCallContext<GetNotesResponse>) -> EventLoopFuture<GRPCStatus> {
        notes.values
            .map { note in
                var response = GetNotesResponse()
                response.note = note
                return response
            }
            .forEach {
                _ = context.sendResponse($0)
            }
        return context.eventLoop.makeSucceededFuture(.ok)
    }
    
    func switchTitleContent(context: StreamingResponseCallContext<SwitchTitleContentResponse>) -> EventLoopFuture<(StreamEvent<SwitchTitleContentRequest>) -> Void> {
        return context.eventLoop.makeSucceededFuture({ [weak self] event in
            switch event {
            case .message(let request):
                if var note = self?.notes[request.note.id] {
                    let title = note.title
                    note.title = note.content
                    note.content = title
                    self?.notes[note.id] = note
                    
                    var response = SwitchTitleContentResponse()
                    response.note = note
                    _ = context.sendResponse(response)
                }
                
            case .end:
                context.statusPromise.succeed(.ok)
            }
        })
    }
}
