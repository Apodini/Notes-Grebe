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
import Grebe_Framework
import Grebe_Generated

class NotesViewModel: ObservableObject {
    typealias Note = NoteProto
    
    @Published var notes = [Note]()
    private let api: API
    private var subscriptions = Set<AnyCancellable>()
    
    init(api: API) {
        self.api = api
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fetchNotes()
        }
    }
    
    func fetchNotes() {
        notes.removeAll()
        api.getNotes()
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
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { [weak self] _ in
                self?.notes.append(note)
            }
            .store(in: &subscriptions)
    }
    
    func delete(notesToDelete: [Note]) {
        api.deleteNotes(notesToDelete)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.notes.removeAll(where: { notesToDelete.contains($0) })
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    func switchTitleContent() {
        let notesToSwitch = notes
        notes.removeAll()
        api.switchTitleContent(notes: notesToSwitch)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { [weak self] response in
                self?.notes.append(response.note)
                print(response.note)
            }
            .store(in: &subscriptions)
    }
}
