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
    var allCategories: [NoteCategory]
    ///Notes
    @Query private var notes: [Note]
    
    init(category: String? = nil, allCategories: [NoteCategory]) {
        self.category = category
        self.allCategories = allCategories
        let predicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }
        
        let favouritesPredicate = #Predicate<Note> {
            return $0.isFavourite
        }
        
        let finalPredicate = category == "All Notes" ? nil : (category == "Favourites" ? favouritesPredicate : predicate)
        
        _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
    }
    
    @FocusState private var isKeyboardEnabled: Bool
    @Environment(\.modelContext) private var context
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            
            let rowCount = max(width / 250, 1)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: Int(rowCount))) {
                    ForEach(notes) { note in
                        NoteCardView(note: note, isKeyboardEnabled: $isKeyboardEnabled)
                            .contextMenu {
                                Button(note.isFavourite ? "Remove from favourites" : "Move to favourites") {
                                    note.isFavourite.toggle()
                                }
                                
                                Menu {
                                    ForEach(allCategories) { category in
                                        Button {
                                            note.category = category
                                        } label : {
                                            HStack(spacing: 5) {
                                                if category == note.category {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption)
                                                }
                                                
                                                Text(category.categoryTitle)
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        note.category = nil
                                    } label: {
                                        Text("Remove from Categories")
                                    }
                                } label: {
                                    Text("Category")
                                }
                                
                                Button("Delete", role: .destructive) {
                                    context.delete(note)
                                }

                            }
                    }
                }.padding(12)
            }
            .onTapGesture {
                isKeyboardEnabled = false
            }
        }
    }
}

struct NoteCardView: View {
    @Bindable var note: Note
    var isKeyboardEnabled: FocusState<Bool>.Binding
    
    var body: some View {
        TextEditor(text: $note.content)
            .focused(isKeyboardEnabled)
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
            .kerning(1.2)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
    }
}

