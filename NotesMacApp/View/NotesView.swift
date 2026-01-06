//
//  NotesView.swift
//  NotesMacApp
//
//  Created by Harpreet Singh on 06/01/26.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    var category: String?
    ///Notes
    @Query private var notes: [Note]
    
    init(category: String? = nil) {
        self.category = category

        let predicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }
        
        let favouritesPredicate = #Predicate<Note> {
            return $0.isFavourite
        }
        
        let finalPredicate = category == "All Notes" ? nil : (category == "Favourites" ? favouritesPredicate : predicate)
        
        _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
    }
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            
            let rowCount = max(width / 250, 1)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: Int(rowCount))) {
                    ForEach(notes) { note in
                        NoteCardView(note: note)
                    }
                }.padding(12)
            }
        }
    }
}

struct NoteCardView: View {
    @Bindable var note: Note
    
    var body: some View {
        TextEditor(text: $note.content)
            .overlay(alignment: .leading, content: {
                Text("Finish Work")
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .opacity(note.content.isEmpty ? 1 : 0)
                    .allowsHitTesting(false)
            })
            .scrollContentBackground(.hidden)
            .multilineTextAlignment(.leading)
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
    }
}

#Preview {
    NotesView()
}
