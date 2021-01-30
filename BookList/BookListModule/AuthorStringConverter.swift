//
//  AuthorStringConverter.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import Foundation

enum AuthorStringConverter {
    static func convertAuthors(_ authors: [Author]?) -> String {
        guard let authors = authors?.compactMap({ $0.name }), authors.count > 0 else {
            return ""
        }
        return authors.joined(separator: ", ")
    }
}
