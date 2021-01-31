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
    func requestImage(path: String, id: UUID, completion: @escaping (UIImage) -> Void)
}

final class SearchService: SearchServiceProtocol {
    private let networkClient: NetworkClient
    private let imageCache = ImageCache<UUID>()

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func request(path: String, completion: @escaping (Result<SearchBookListEntity, Error>) -> Void) {
        self.networkClient.request(path: path, completion: completion)
    }

    func requestImage(path: String, id: UUID, completion: @escaping (UIImage) -> Void) {
        if let image = imageCache.image(key: id) {
            completion(image)
            return
        } else {
            self.networkClient.request(path: path) { [weak self] image in
                self?.imageCache.save(image: image, key: id)
                completion(image)
            }
        }
    }
}
