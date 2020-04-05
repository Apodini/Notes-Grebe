//
//  ContentView.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 12.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import SwiftUI
import Grebe_Framework
import Grebe_Generated

struct NotesView: View {
    @ObservedObject var model: NotesViewModel

    @State var presentingCreateSheet = false
    @State var editMode: EditMode = .inactive
    @State var selection = Set<NoteProto>()

    init(model: NotesViewModel) {
        self.model = model
    }

    var body: some View {
        return NavigationView {
            VStack {
                notesList
                toolbar
            }
            .navigationBarTitle(Text("Notes"))
            .navigationBarItems(leading: editButton,
                                trailing: trailingButton)
            .environment(\.editMode, self.$editMode)
            .sheet(isPresented: self.$presentingCreateSheet, content: {
                CreateNoteView(model: CreateNoteViewModel(create: self.model.createNote))
            })
        }
    }

    private var notesList: some View {
        List(selection: $selection) {
            ForEach(model.notes) { note in
                NoteCell(title: note.title, content: note.content)
            }
            .onDelete(perform: delete)
        }
    }

    private var toolbar: some View {
        HStack {
            Button(action: model.switchTitleContent) {
                Text("Title ↔︎ Content")
            }
            Spacer()
        }.padding()
    }

    private var trailingButton: some View {
        if editMode == .inactive {
            return AnyView(refreshButton)
        } else if editMode == .active, !selection.isEmpty {
            return AnyView(deleteButton)
        }
        return AnyView(addButton)
    }

    private var addButton: some View {
        Button(action: { self.presentingCreateSheet = true }) {
            Image(systemName: "plus")
        }
    }

    private var refreshButton: some View {
        Button(action: model.fetchNotes) {
            Image(systemName: "arrow.2.circlepath")
        }
    }

    private var editButton: some View {
        Button(action: {
            self.editMode.toggle()
            self.selection = Set<NoteProto>()
        }) {
            Text(self.editMode.title)
        }
    }

    private var deleteButton: some View {
        Button(action: { self.model.delete(notesToDelete: Array(self.selection)) }) {
            Image(systemName: "trash")
        }
    }

    private func delete(at indexSet: IndexSet) {
        var notes = [NoteProto]()
        _ = indexSet.map { notes.append(model.notes[$0]) }
        model.delete(notesToDelete: notes)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(model: NotesViewModel(api: API()))
    }
}

extension NoteProto: Identifiable {}

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
