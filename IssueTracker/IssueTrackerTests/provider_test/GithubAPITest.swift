//
//  GithubAPITest.swift
//  IssueTrackerTests
//
//  Created by 김동준 on 2022/06/21.
//

import XCTest
import Moya
import RxSwift
@testable import IssueTracker

class GithubAPITest: XCTestCase {
    var issueRequestable: GitHubIssueRequestable!
    
    override func setUpWithError() throws {
        issueRequestable = GithubIssueRepositoryStub()
    }
    
    func testTokenExchange() throws {
        let expectation = XCTestExpectation()
        guard let json = Bundle.main.path(forResource: "MockIssueList", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: json) else { return }
        guard let mockData = jsonString.data(using: .utf8) else { return }
        guard let expectedCount = try? JSONDecoder().decode([Issue].self, from: mockData).count else { return }
        
        issueRequestable.requestIssues()
            .map { $0.count }
            .bind { count in
                XCTAssertEqual(expectedCount, count)
                expectation.fulfill()
            }
            .dispose()
        wait(for: [expectation], timeout: 1.0)
    }
}
