//
//  SearchService.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import Foundation
import UIKit

protocol SearchServiceProtocol {
    func request(path: String, completion: @escaping (Result<SearchBookListEntity, Error>) -> Void)
    func requestImage(path: String, completion: @escaping (UIImage) -> Void)
}

final class SearchService: SearchServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func request(path: String, completion: @escaping (Result<SearchBookListEntity, Error>) -> Void) {
        self.networkClient.request(path: path) { (result: Result<SearchBookListEntity, Error>) in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func requestImage(path: String, completion: @escaping (UIImage) -> Void) {
        self.networkClient.request(path: path, completion: completion)
    }
}
