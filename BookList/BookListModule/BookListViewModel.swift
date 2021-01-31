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

    private let searchService: SearchServiceProtocol
    private let stringConverter: AuthorStringConverterProtocol
    private var items = [BookSetupModel]()
    private var currentPage = "10"
    private var isDownlaoding = false

    init(searchService: SearchServiceProtocol = SearchService(), stringConverter: AuthorStringConverterProtocol = AuthorStringConverter()) {
        self.searchService = searchService
        self.stringConverter = stringConverter
    }

    func downloadBooks() {
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
                                authors: self.stringConverter.convertAuthors($0.authors),
                                narrators: self.stringConverter.convertAuthors($0.narrators)
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
        self.searchService.requestImage(path: url, id: id) { image in
            completion(image, id)
        }
    }
}
