//
//  Note.swift
//  NotesMacApp
//
//  Created by Harpreet Singh on 05/01/26.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var content: String
    var isFavourite: Bool = false
    var category: NoteCategory?
    
    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}

