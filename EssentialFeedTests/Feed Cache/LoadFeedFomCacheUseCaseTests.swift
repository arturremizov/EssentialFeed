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
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversCachedImagesOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(feed.models), when: {
            store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        })
    }
    
    func test_load_deliversNoImagesOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
        })
    }
    
    func test_load_deliversNoImagesOnMoreSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let moreThansevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: feed.local, timestamp: moreThansevenDaysOldTimestamp)
        })
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let ext = expectation(description: "Wait for load completion")
        
        sut.load() { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(recievedImages), .success(expectedImages)):
                XCTAssertEqual(recievedImages, expectedImages, file: file, line: line)
            case let (.failure(recievedError), .failure(expectedError)):
                XCTAssertEqual(recievedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(recievedResult) instead", file: file, line: line)
            }
            ext.fulfill()
        }

        action()
        wait(for: [ext], timeout: 1)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func uniqueImage() -> FeedImage {
        return FeedImage(id: UUID(), url: anyURL())
    }
    
    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
        return (models, local)
    }
}

private extension Date {
    
    func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
