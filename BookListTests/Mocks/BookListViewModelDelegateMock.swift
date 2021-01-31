//
//  BookListViewModelDelegateMock.swift
//  BookListTests
//
//  Created by Gregory Oberemkov on 31.01.2021.
//

import Foundation
@testable import BookList

final class BookListViewModelDelegateMock: BookListViewModelDelegate {
    var reloadingCounter = 0
    var errorCounter = 0

    func reloadTableView() {
        reloadingCounter += 1
    }
    
    func showErrorState() {
        errorCounter += 1
    }
}
