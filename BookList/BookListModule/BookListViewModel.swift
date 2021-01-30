//
//  BookListViewModel.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import Foundation

protocol BookListViewModelDelegate {
    func reloadTableView()
    func showErrorState()
}

final class BookListViewModel {
    typealias SearchResult = Result<SearchBookListEntity, Error>

    var delegate: BookListViewModelDelegate?

    private let imageCache = ImageCache<UUID>()
    private let searchService: SearchServiceProtocol
    private var items = [BookSetupModel]()
    private var currentPage = "10"
    private var isDownlaoding = false
    
    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }

    func downlaodBooks() {
        if !isDownlaoding {
            self.isDownlaoding = true
            searchService.request(path: "search?query=harry&page=\(currentPage)") {  [weak self] (result: SearchResult) in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    if let newItems = value.items {
                        let setupItems = newItems.map {
                            BookSetupModel(
                                id: UUID(),
                                url: $0.cover?.url ?? "",
                                title: $0.title ?? "",
                                authors: AuthorStringConverter.convertAuthors($0.authors),
                                narrators: AuthorStringConverter.convertAuthors($0.narrator)
                            )
                        }
                        self.items.append(contentsOf: setupItems)
                    }
                    self.currentPage = value.nextPageToken
                    self.delegate?.reloadTableView()
                    self.isDownlaoding = false
                case .failure:
                    self.delegate?.showErrorState()
                    self.isDownlaoding = false
                }
            }
        }
    }

    func getItems() -> [BookSetupModel] {
        return self.items
    }

    func getElement(atIndex index: Int) -> BookSetupModel {
        return self.items[index]
    }

    func loadBookCover(url: String, id: UUID, completion: @escaping BookListViewController.BookCoverLoadCompletion) {
        if let image = imageCache.image(key: id) {
            completion(image.decodedImage(), id)
            return 
        } else {
            self.searchService.requestImage(path: url) { image in
                completion(image, id)
                let img = image.decodedImage()
                self.imageCache.save(image: img, key: id)
            }
        }
    }
}
