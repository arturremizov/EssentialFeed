//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Artur Remizov on 31.05.23.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
