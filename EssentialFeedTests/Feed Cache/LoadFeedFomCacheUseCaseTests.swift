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
        sut.load() { error in
            recievedError = error
            ext.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [ext], timeout: 1)

        XCTAssertEqual(recievedError as? NSError, retrievalError)
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
