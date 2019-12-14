//
//  NoteCell.swift
//  Notes-gRPC-App
//
//  Created by Tim Mewe on 14.12.19.
//  Copyright © 2019 Tim Mewe. All rights reserved.
//

import SwiftUI

struct NoteCell: View {
    @State var title: String
    @State var content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            Text(content)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
        }
    }
}

struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell(title: "Test", content: "fasfasfsa")
    }
}
