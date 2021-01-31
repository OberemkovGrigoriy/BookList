//
//  Models.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import Foundation
import UIKit

struct SearchBookListEntity: Codable {
    let nextPageToken: String
    let items: [BookEntity]?
}

struct BookSetupModel {
    let id: UUID
    let url: String
    let title: String
    let authors: String
    let narrators: String
}

struct BookEntity: Codable {
    let id: String
    let title: String?
    let cover: BookCover?
    let authors: [Author]?
    let narrators: [Author]?
}

struct Author: Codable {
    let name: String?
}

struct BookCover: Codable {
    let url: String?
}
