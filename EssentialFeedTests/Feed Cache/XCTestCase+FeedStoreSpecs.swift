//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Artur Remizov on 10.06.23.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrieval")
        var expectedError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { insertionError in
            expectedError = insertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return expectedError
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let ext = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCacheFeed { error in
            deletionError = error
            ext.fulfill()
        }
        wait(for: [ext], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: FeedStore, toRetieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetieve: expectedResult, file: file, line: line)
        expect(sut, toRetieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: FeedStore, toRetieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                 (.failure, .failure):
                break
            case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
                XCTAssertEqual(expectedFeed, retrievedFeed)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead.", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
