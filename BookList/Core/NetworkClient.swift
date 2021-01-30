//
//  NetworkClient.swift
//  BookList
//
//  Created by Gregory Oberemkov on 29.01.2021.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit
import CoreGraphics

protocol NetworkClientProtocol {
    func request<T: Decodable>(path: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void)
    func request(path: String, completion: @escaping (UIImage) -> Void)
}

final class NetworkClient: NetworkClientProtocol {
    enum NetworkError: Error {
        case urlIsIncorrect
        case connection
    }
    let imageCache = AutoPurgingImageCache()
    private let base = "https://api.storytel.net"
    func request<T: Decodable>(path: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = base + "/" + path
        let request = AF.request(urlString, parameters: parameters)
        
        if request.error?.isCreateURLRequestError != nil {
            completion(.failure(NetworkError.urlIsIncorrect))
        }
        request.responseDecodable(of: T.self) { response in
            guard let value = response.value else {
                completion(.failure(NetworkError.connection))
                return
            }
            
            completion(.success(value))
        }
    }
    
    func request(path: String, completion: @escaping (UIImage) -> Void) {
        AF.request(path).responseImage { response in
            if case .success(let image) = response.result {
                completion(image)
            }
        }
    }
}

extension UIImage {
func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
}
