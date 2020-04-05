//
//  ContentView.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 12.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Grebe_Framework
import Grebe_Generated
import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel

    // MARK: - Private Properties

    @State private var presentingCreateSheet = false
    @State private var selection = Set<Note>()

    // MARK: - Lifecycle

    init(model: NotesViewModel) {
        viewModel = model
    }

    // MARK: - Main View

    var body: some View {
        return NavigationView {
            VStack {
                notesList
                toolbar
            }
            .sheet(isPresented: self.$presentingCreateSheet, content: {
                CreateNoteView(model: CreateNoteViewModel(create: self.viewModel.createNote))
            })
        }
    }

    // MARK: - Other Views

    private var notesList: some View {
        List(viewModel.notes, id: \.self, selection: $selection) { note in
            NoteCell(title: note.title, content: note.content)
        }
        .navigationBarItems(leading: EditButton(), trailing: addButton)
        .navigationBarTitle(Text("Notes"))
    }

    private var toolbar: some View {
        HStack {
            Button(action: viewModel.switchTitleContent) {
                Text("Title ↔︎ Content")
            }
            Spacer()
            if !selection.isEmpty {
                deleteButton
            }
        }.padding()
    }

    private var addButton: some View {
        Button(action: { self.presentingCreateSheet = true }) {
            Image(systemName: "plus")
        }
    }

    private var refreshButton: some View {
        Button(action: viewModel.fetchNotes) {
            Image(systemName: "arrow.2.circlepath")
        }
    }

    private var deleteButton: some View {
        Button(action: {
            self.viewModel.delete(notesToDelete: Array(self.selection))
            self.selection.removeAll()
        }) {
            Image(systemName: "trash")
        }
    }

    private func delete(at indexSet: IndexSet) {
        var notes = [NoteProto]()
        _ = indexSet.map { notes.append(viewModel.notes[$0]) }
        viewModel.delete(notesToDelete: notes)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(model: NotesViewModel(api: API()))
    }
}

// MARK: - EditMode Extension

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
