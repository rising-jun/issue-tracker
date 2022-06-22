//
//  GithubAPITest.swift
//  IssueTrackerTests
//
//  Created by 김동준 on 2022/06/20.
//

import XCTest
import Moya
import RxSwift
@testable import IssueTracker

class GithubTokenExchangeTest: XCTestCase {
    var tokenExchangable: GitHubTokenExchangable!
    
    override func setUpWithError() throws {
        tokenExchangable = GithubTokenRepositoryStub()
    }
    
    func testTokenExchange() throws {
        let expectation = XCTestExpectation()
        guard let json = Bundle.main.path(forResource: "MockAccessToken", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: json) else { return }
        guard let mockData = jsonString.data(using: .utf8) else { return }
        guard let expectedToken = try? JSONDecoder().decode(Token.self, from: mockData).accessToken else { return }
        
        tokenExchangable.exchangeToken(by: "code")
            .bind { token in
                XCTAssertEqual(expectedToken, token)
                expectation.fulfill()
            }
            .dispose()
        wait(for: [expectation], timeout: 1.0)
    }
}
