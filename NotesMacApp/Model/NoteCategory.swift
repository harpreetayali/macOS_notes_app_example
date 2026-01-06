//
//  NoteCategory.swift
//  NotesMacApp
//
//  Created by Harpreet Singh on 05/01/26.
//

import SwiftUI
import SwiftData

@Model
class NoteCategory {
    var categoryTitle: String
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
