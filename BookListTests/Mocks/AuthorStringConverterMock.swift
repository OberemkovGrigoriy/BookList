//
//  AuthorStringConverterMock.swift
//  BookListTests
//
//  Created by Gregory Oberemkov on 31.01.2021.
//

import Foundation
@testable import BookList

final class AuthorStringConverterMock: AuthorStringConverterProtocol {
    var authors: [Author]?
    var resultString = ""
    var convertorIsInvokedCounter = 0

    func convertAuthors(_ authors: [Author]?) -> String {
        self.authors = authors
        convertorIsInvokedCounter += 1
        return resultString
    }

}
