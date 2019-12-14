//
//  NotesViewModel.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    typealias Note = NoteProto
    
    @Published var notes = [Note]()
    private let api: API
    private var subscriptions = Set<AnyCancellable>()
    
    init(api: API) {
        self.api = api
        var note = NoteProto()
        note.id = "1"
        note.title = "Test"
        note.content = "Test Content"
        createNote(note)
    }
    
    func fetchNotes() {
        notes.removeAll()
        api.getNotes()
            .print("GET NOTES")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { [weak self] response in
                self?.notes.append(response.note)
            }
            .store(in: &subscriptions)
    }
    
    func createNote(_ note: Note) {
        var request = CreateNoteRequest()
        request.note = note
        api.createNote(note)
            .print("CREATE NOTES")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { [weak self] response in
                self?.notes.append(note)
            }
            .store(in: &subscriptions)
    }
}
