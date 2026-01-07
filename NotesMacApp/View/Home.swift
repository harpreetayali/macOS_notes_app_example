//
//  Home.swift
//  NotesMacApp
//
//  Created by Harpreet Singh on 05/01/26.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var selectedTag: String?  = "All Notes"
    
    @Query(animation: .snappy) private var categories: [NoteCategory]
    
    @Environment(\.modelContext) private var context
    
    @State private var addCategory: Bool = false
    @State private var categoryTitle: String = ""
    @State private var requestCategory: NoteCategory?
    @State private var deleteRequest: Bool = false
    @State private var renameRequest: Bool = false
    /// Dark mode toggle
    @State private var isDark: Bool = true
    
    var body: some View {
        
        NavigationSplitView {
            List(selection: $selectedTag) {
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundStyle(selectedTag == "All Notes" ? .primary : Color.gray)
                
                Text("Favourites")
                    .tag("Favourites")
                    .foregroundStyle(selectedTag == "Favourites" ? .primary : Color.gray)
                
                Section {
                    ForEach(categories) { category in
                        Text(category.categoryTitle)
                            .tag(category.categoryTitle)
                            .foregroundStyle(selectedTag == category.categoryTitle ? Color.primary : Color.gray)
                            .contextMenu {
                                Button("Rename") {
                                    categoryTitle = category.categoryTitle
                                    requestCategory = category
                                    renameRequest = true
                                }
                                Button("Delete") {
                                    categoryTitle = category.categoryTitle
                                    requestCategory = category
                                    deleteRequest = true
                                }
                            }
                    }
                } header: {
                    HStack(spacing: 5) {
                        Text("Categories")
                        
                        Button("", systemImage: "plus") {
                            addCategory.toggle()
                        }
                        .tint(.gray)
                        .buttonStyle(.plain)
                    }
                }

            }
        } detail: {
            NotesView(category: selectedTag, allCategories: categories)
        }
        .navigationTitle(selectedTag ?? "Notes")
        /// Adding Category Alert
        .alert("Add Category", isPresented: $addCategory) {
            TextField("Record Video", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
            }
            
            Button("Add") {
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
        }
        /// Rename Category Alert
        .alert("Rename Category", isPresented: $renameRequest) {
            TextField("Work", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestCategory = nil
            }
            
            Button("Rename") {
                if let requestCategory {
                    requestCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestCategory = nil
                }
                
            }
        }
        /// Delete Category Alert
        .alert("Are you sure to delete \(categoryTitle) category", isPresented: $deleteRequest) {

            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestCategory = nil
            }
            
            Button("Delete", role: .destructive) {
                if let requestCategory {
                    context.delete(requestCategory)
                    self.requestCategory = nil
                }
                
            }
        }
        ///Toolbar items
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 10) {
                    Button("", systemImage: "plus") {
                        let note = Note(content: "")
                        context.insert(note)
                    }
                    
                    Button("", systemImage: isDark ? "sun.min" : "moon") {
                        isDark.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        /// Color Scheme
        .preferredColorScheme(isDark ? .dark : .light)

    }
}

