//
//  ImageCache.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import UIKit

final class ImageCache<Key: Hashable & ReferenceConvertible> {
    private let cache: NSCache<Key.ReferenceType, UIImage>

    init() {
        self.cache = .init()
        self.cache.countLimit = 40
    }

    func save(image: UIImage, key: Key) {
        self.cache.setObject(image, forKey: key as! Key.ReferenceType)
    }

    func image(key: Key) -> UIImage? {
        return self.cache.object(forKey: key as! Key.ReferenceType)
    }
}

