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

    init(model: NotesViewModel) {
        self.model = model
    }

    var body: some View {
        return NavigationView {
            List {
                ForEach(model.notes) { note in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(note.title)
                        Text(note.content)
                    }
                }
            }
            .navigationBarTitle(Text("Notes"))
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(model: NotesViewModel(api: API()))
    }
}

extension NoteProto: Identifiable {}
