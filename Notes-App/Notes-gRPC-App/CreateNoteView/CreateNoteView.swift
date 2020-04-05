//
//  CreateNoteView.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import Grebe_Generated
import SwiftUI

struct CreateNoteView: View {
    @ObservedObject var viewModel: CreateNoteViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Private Properties

    @State private var title: String = ""
    @State private var content: String = ""

    // MARK: - Lifecycle

    init(model: CreateNoteViewModel) {
        self.viewModel = model
    }

    // MARK: - Main View

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
                    self.viewModel.createNote(title: self.title, content: self.content)
                    self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CreateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        let noteModel = NotesViewModel(api: API())
        return CreateNoteView(model: CreateNoteViewModel(create: noteModel.createNote))
    }
}
