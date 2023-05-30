//
//  LoadFeedFomCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Artur Remizov on 30.05.23.
//

import XCTest
import EssentialFeed

final class LoadFeedFomCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        let ext = expectation(description: "Wait for load completion")
        
        var recievedError: Error?
        sut.load() { result in
            switch result {
            case .failure(let error):
                recievedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            ext.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [ext], timeout: 1)

        XCTAssertEqual(recievedError as? NSError, retrievalError)
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        var receivedImages: [FeedImage]?
        let ext = expectation(description: "Wait for load completion")
        sut.load() { result in
            switch result {
            case let .success(images):
                receivedImages = images
            default:
                XCTFail("Expected success, got \(result) instead")
            }
            ext.fulfill()
        }

        store.completeRetrievalWithEmptyCache()
        wait(for: [ext], timeout: 1)

        XCTAssertEqual(receivedImages, [])
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
