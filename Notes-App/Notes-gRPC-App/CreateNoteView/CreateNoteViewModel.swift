//
//  CreateNoteViewModel.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Foundation
import Grebe_Framework
import Grebe_Generated

internal final class CreateNoteViewModel: ObservableObject {
    // MARK: - External Dependencies
    
    typealias CreateNoteClosure = (_ note: NoteProto) -> Void
    private let create: CreateNoteClosure
    
    // MARK: - Lifecycle
    
    init(create: @escaping CreateNoteClosure) {
        self.create = create
    }
    
    func createNote(title: String, content: String) {
        guard !title.isEmpty && !content.isEmpty else { return }
        
        var note = Note()
        note.id = UUID().uuidString
        note.title = title
        note.content = content
        
        create(note)
    }
}
