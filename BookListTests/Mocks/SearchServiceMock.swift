//
//  SearchServiceMock.swift
//  BookListTests
//
//  Created by Gregory Oberemkov on 31.01.2021.
//

import Foundation
import UIKit
@testable import BookList

final class SearchServiceMock: SearchServiceProtocol {
    var requestImagePath: String?
    var requestPath: String?
    var requestCounter = 0
    var requestImageCounter = 0
    
    var requestResult: Result<SearchBookListEntity, Error>!
    var requestImageResult: UIImage!
    
    func request(path: String, completion: @escaping (Result<SearchBookListEntity, Error>) -> Void) {
        self.requestPath = path
        self.requestCounter += 1
        completion(requestResult)
    }
    
    func requestImage(path: String, id: UUID, completion: @escaping (UIImage) -> Void) {
        self.requestImagePath = path
        self.requestImageCounter += 1
        completion(requestImageResult)
    }
}
