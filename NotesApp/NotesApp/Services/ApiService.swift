//
//  ApiService.swift
//  NotesApp
//
//  Created by Emmanuel Ugwuoke on 23/07/2024.
//

import Foundation


class ApiService {
    static let baseUrl = "http://localhost:4000"
    static var getNotes = "\(ApiService.baseUrl)/notes"
    static var createNote = "\(ApiService.baseUrl)/note"
    static func patchNote(_ id:String) -> String {
        return "\(ApiService.baseUrl)/note/\(id)"
    }
    static func deleteNote(_ id:String) -> String {
        return "\(ApiService.baseUrl)/note/\(id)"
    }
}
