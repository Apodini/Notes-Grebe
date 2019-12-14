//
//  CreateNoteView.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import SwiftUI

struct CreateNoteView: View {
    @ObservedObject var model: CreateNoteViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State private var title: String = ""
    @State private var content: String = ""

    init(model: CreateNoteViewModel) {
        self.model = model
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Content", text: $content)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }
            .padding(15)
            .navigationBarTitle("Create Note", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Save") {
                    self.model.createNote(title: self.title, content: self.content)
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct CreateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        let noteModel = NotesViewModel(api: API())
        return CreateNoteView(model: CreateNoteViewModel(create: noteModel.createNote))
//        return EmptyView()
    }
}
