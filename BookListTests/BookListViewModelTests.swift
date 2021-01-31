//
//  BookListViewModelTests.swift
//  BookListTests
//
//  Created by Gregory Oberemkov on 31.01.2021.
//

import XCTest
@testable import BookList

final class BookListViewModelTests: XCTestCase {
    enum NetworkErrorStub: Error {
        case error
    }

    private let searchService: SearchServiceMock = SearchServiceMock()
    private let stringConverter: AuthorStringConverterMock = AuthorStringConverterMock()
    private let delegateMock: BookListViewModelDelegateMock = BookListViewModelDelegateMock()
    func initialTestingViewModel() -> BookListViewModel {
        let viewModel = BookListViewModel(
            searchService: self.searchService,
            stringConverter: self.stringConverter
        )
        viewModel.delegate = delegateMock
        return viewModel
    }

    func testDownloadEmptyBooks() throws {
        // GIVEN
        let viewModel = initialTestingViewModel()
        // WHEN
        self.searchService.requestResult = .success(SearchBookListEntity(nextPageToken: "20", items: nil))
        viewModel.downloadBooks()
        // THEN
        XCTAssert(stringConverter.resultString == "")
        XCTAssert(stringConverter.authors == nil)
        XCTAssert(stringConverter.convertorIsInvokedCounter == 0)
        XCTAssert(delegateMock.reloadingCounter == 1)
        XCTAssert(delegateMock.errorCounter == 0)
        XCTAssert(searchService.requestCounter == 1)
        XCTAssert(searchService.requestPath == "search?query=harry&page=10")
        XCTAssert(viewModel.getItems().count == 0)
    }

    func testDownloadBookItems() throws {
        // GIVEN
        let viewModel = initialTestingViewModel()
        let bookEntities = [
            BookEntity(id: "id", title: "title", cover: nil, authors: nil, narrators: nil),
            BookEntity(id: "secondID", title: "title", cover: nil, authors: nil, narrators: nil)
        ]
        // WHEN
        self.searchService.requestResult = .success(SearchBookListEntity(nextPageToken: "20", items: bookEntities))
        viewModel.downloadBooks()
        // THEN
        XCTAssert(stringConverter.resultString == "")
        XCTAssert(stringConverter.authors == nil)
        XCTAssert(stringConverter.convertorIsInvokedCounter == 4)
        XCTAssert(delegateMock.reloadingCounter == 1)
        XCTAssert(delegateMock.errorCounter == 0)
        XCTAssert(searchService.requestCounter == 1)
        XCTAssert(searchService.requestPath == "search?query=harry&page=10")
        XCTAssert(viewModel.getItems().count == 2)
    }

    func testDownloadBookItemsTwice() throws {
        // GIVEN
        let viewModel = initialTestingViewModel()
        let bookEntities = [
            BookEntity(id: "id", title: "title", cover: nil, authors: nil, narrators: nil),
            BookEntity(id: "secondID", title: "title", cover: nil, authors: nil, narrators: nil)
        ]
        // WHEN
        self.searchService.requestResult = .success(SearchBookListEntity(nextPageToken: "20", items: bookEntities))
        viewModel.downloadBooks()
        self.searchService.requestResult = .success(SearchBookListEntity(nextPageToken: "30", items: bookEntities))
        viewModel.downloadBooks()
        // THEN
        XCTAssert(stringConverter.resultString == "")
        XCTAssert(stringConverter.authors == nil)
        XCTAssert(stringConverter.convertorIsInvokedCounter == 8)
        XCTAssert(delegateMock.reloadingCounter == 2)
        XCTAssert(delegateMock.errorCounter == 0)
        XCTAssert(searchService.requestCounter == 2)
        XCTAssert(searchService.requestPath == "search?query=harry&page=20")
        XCTAssert(viewModel.getItems().count == 4)
    }

    func testDownloadBookItemsFail() throws {
        // GIVEN
        let viewModel = initialTestingViewModel()
        // WHEN
        searchService.requestResult = .failure(NetworkErrorStub.error)
        viewModel.downloadBooks()
        // THEN
        XCTAssert(stringConverter.resultString == "")
        XCTAssert(stringConverter.authors == nil)
        XCTAssert(stringConverter.convertorIsInvokedCounter == 0)
        XCTAssert(delegateMock.reloadingCounter == 0)
        XCTAssert(delegateMock.errorCounter == 1)
        XCTAssert(searchService.requestCounter == 1)
        XCTAssert(searchService.requestPath == "search?query=harry&page=10")
        XCTAssert(viewModel.getItems().count == 0)
    }

    func testDownloadImage() throws {
        // GIVEN
        let viewModel = initialTestingViewModel()
        let path = "urlPath"
        let id = UUID()
        let resultImage = UIImage()
        // WHEN
        self.searchService.requestImageResult = resultImage
        viewModel.loadBookCover(url: path, id: id) { (image, uuid) in
            // THEN
            XCTAssert(uuid == id)
            XCTAssert(resultImage == image)
            XCTAssert(self.searchService.requestImagePath == path)
            XCTAssert(self.searchService.requestImageCounter == 1)
        }
    }
    

    func testAuthorIsNilStringConverter() {
        // GIVEN
        let converter = AuthorStringConverter()
        let authors: [Author]? = nil
        // WHEN
        let result = converter.convertAuthors(authors)
        // THEN
        XCTAssert(result == "")
    }

    func testAuthorIsEmptyStringConverter() {
        // GIVEN
        let converter = AuthorStringConverter()
        let authors = [Author]()
        // WHEN
        let result = converter.convertAuthors(authors)
        // THEN
        XCTAssert(result == "")
    }

    func testAuthorIsSingleElementStringConverter() {
        // GIVEN
        let converter = AuthorStringConverter()
        let authors = [Author(name: "name")]
        // WHEN
        let result = converter.convertAuthors(authors)
        // THEN
        XCTAssert(result == "name")
    }

    func testAuthorIsMultipleElementStringConverter() {
        // GIVEN
        let converter = AuthorStringConverter()
        let authors = [Author(name: "name"), Author(name: "secondName")]
        // WHEN
        let result = converter.convertAuthors(authors)
        // THEN
        XCTAssert(result == "name, secondName")
    }
}
