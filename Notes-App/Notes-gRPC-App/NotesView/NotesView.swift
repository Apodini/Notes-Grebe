//
//  ContentView.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 12.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var model: NotesViewModel
    @State var presentingCreateSheet = false

    init(model: NotesViewModel) {
        self.model = model
    }

    var body: some View {
        return NavigationView {
            List {
                ForEach(model.notes) { note in
                    NoteCell(title: note.title, content: note.content)
                }
            }
            .navigationBarTitle(Text("Notes"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentingCreateSheet = true
                }) {
                    Image(systemName: "plus")
            })
            .sheet(isPresented: self.$presentingCreateSheet, content: {
                CreateNoteView(model: CreateNoteViewModel(create: self.model.createNote))
            })
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(model: NotesViewModel(api: API()))
    }
}

extension NoteProto: Identifiable {}
