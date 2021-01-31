//
//  AuthorStringConverter.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import Foundation

protocol AuthorStringConverterProtocol {
    func convertAuthors(_ authors: [Author]?) -> String
}

final class AuthorStringConverter: AuthorStringConverterProtocol {
    func convertAuthors(_ authors: [Author]?) -> String {
        guard let authors = authors?.compactMap({ $0.name }), authors.count > 0 else {
            return ""
        }
        return authors.joined(separator: ", ")
    }
}
