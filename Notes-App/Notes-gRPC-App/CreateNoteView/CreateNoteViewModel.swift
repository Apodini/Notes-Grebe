//
//  CreateNoteViewModel.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Foundation

class CreateNoteViewModel: ObservableObject {
    typealias Note = NoteProto
    typealias CreateNoteClosure = (_ note: NoteProto) -> Void
    private let create: CreateNoteClosure
    
    init(create: @escaping CreateNoteClosure) {
        self.create = create
    }
    
    func createNote(title: String, content: String) {
        var note = Note()
        note.id = UUID().uuidString
        note.title = title
        note.content = content

        create(note)
    }
}
